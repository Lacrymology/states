{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set filter_type = salt['pillar.get']('carbon:filter:type', None) -%}
{%- set supported_filter_types = ('white', 'black')  %}

include:
  - cron
  - hostname
  - graphite.common
  - logrotate
  - local
  - pip
  - pysc
  - python.dev

/etc/logrotate.d/carbon:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://carbon/logrotate.jinja2
    - require:
      - pkg: logrotate

/var/log/graphite/carbon:
  file:
    - directory
    - user: root
    - group: graphite
    - mode: 770
    - makedirs: True
    - require:
      - user: graphite
      - file: /var/log/graphite

/etc/graphite/storage-schemas.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: graphite
    - mode: 440
    - source: salt://carbon/storage.jinja2
    - require:
      - user: graphite
      - file: /etc/graphite

/usr/local/graphite/salt-carbon-requirements.txt:
  file:
    - absent

carbon:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/carbon
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://carbon/requirements.jinja2
    - require:
      - virtualenv: graphite
      - host: hostname
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/graphite/bin/pip
    - requirements: {{ opts['cachedir'] }}/pip/carbon
    - install_options:
      - "--prefix=/usr/local/graphite"
      - "--install-lib=/usr/local/graphite/lib/python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}/site-packages"
    - watch:
      - file: carbon
      - pkg: python-dev
  cmd:
    - wait
    - name: find /usr/local/graphite -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: carbon

/etc/graphite/carbon.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://carbon/config.jinja2
    - context:
        filtering: {% if filter_type in supported_filter_types %}True{% else %}False{% endif %}
    - require:
      - file: /etc/graphite

{%- set instances_count = salt['pillar.get']('carbon:cache_daemons') %}

{#- PID file owned by root, no need to manage #}
{% for instance in range(instances_count) %}
carbon-cache-{{ instance }}:
  file:
    - managed
    - name: /etc/init.d/carbon-cache-{{ instance }}
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://carbon/init.jinja2
    - context:
        instance: {{ instance }}
  service:
    - running
    - enable: True
    - order: 50
{# until https://github.com/saltstack/salt/issues/5027 is fixed, this is required #}
    - sig: /usr/local/graphite/bin/python /usr/local/graphite/bin/carbon-cache.py --config=/etc/graphite/carbon.conf --instance={{ instance }} start
    - name: carbon-cache-{{ instance }}
    - require:
      - user: graphite
{#- carbon periodically reload this file, doesn't need to watch it #}
      - file: /etc/graphite/storage-aggregation.conf
      - file: /var/log/graphite/carbon
      - file: /var/lib/graphite/whisper/{{ instance }}
    - watch:
      - module: carbon
      - cmd: carbon
      - file: /etc/graphite/carbon.conf
      - file: /etc/graphite/storage-schemas.conf
      - file: carbon-cache-{{ instance }}
      - cmd: carbon
{% endfor %}

{% set prefix = '/etc/init.d/' %}
{% for filename in salt['file.find'](prefix, name='carbon-cache-*', type='f') %}
  {% set instance = filename.replace(prefix + 'carbon-cache-', '') %}
  # get not_in_use_instance
  {%- if instance|int >= instances_count|int %}
remove_not_in_use_instance_{{ instance }}:
  service:
    - dead
    - name: carbon-cache-{{ instance }}
  file:
    - absent
    - name: {{ prefix }}carbon-cache-{{ instance }}
    - require:
      - service: remove_not_in_use_instance_{{ instance }}

/var/log/graphite/carbon/carbon-cache-{{ instance }}:
  file:
    - absent
    - require:
      - service: remove_not_in_use_instance_{{ instance }}

/var/lib/graphite/whisper/{{ instance }}:
  file:
    - absent
    - require:
      - service: remove_not_in_use_instance_{{ instance }}
  {%- endif %}
{% endfor %}

carbon-relay:
  file:
    - managed
    - name: /etc/init.d/carbon-relay
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://carbon/init.jinja2
  service:
    - running
    - enable: True
    - order: 50
{# until https://github.com/saltstack/salt/issues/5027 is fixed, this is required #}
    - sig: /usr/local/graphite/bin/python /usr/local/graphite/bin/carbon-relay.py --config=/etc/graphite/carbon.conf start
    - name: carbon-relay
    - require:
      - file: /var/log/graphite/carbon
      - file: /var/lib/graphite
    - watch:
      - user: graphite
      - module: carbon
      - cmd: carbon
      - file: /etc/graphite/carbon.conf
      - file: /etc/graphite/storage-schemas.conf
      - file: carbon-relay
      - file: /etc/graphite/relay-rules.conf
      - cmd: carbon

/etc/graphite/relay-rules.conf:
  file:
    - managed
    - source: salt://carbon/relay-rules.jinja2
    - template: jinja
    - user: root
    - group: graphite
    - mode: 440
    - require:
      - user: graphite
      - file: /etc/graphite

/var/lib/graphite/lists:
  file:
{%- if filter_type not in supported_filter_types %}
    - absent
{%- else %}
    - directory
    - user: root
    - group: graphite
    - mode: 550
    - require:
      - file: /var/lib/graphite
{%- endif -%}

{%- for all_filter_type in supported_filter_types %}
/etc/graphite/{{ all_filter_type }}list.conf:
  file:
  {%- if all_filter_type == filter_type %}
    - managed
    - user: root
    - group: graphite
    - mode: 440
    - contents: |
     {%- for rule in salt['pillar.get']('carbon:filter:rules', []) %}
        {{ rule }}
     {%- endfor %}
    - require:
      - user: graphite
      - file: /etc/graphite
      - file: /var/lib/graphite/lists
    - watch_in:
      {%- for instance in range(instances_count) %}
      - service: carbon-cache-{{ instance }}
      {%- endfor -%}
  {%- else %}
    - absent
  {%- endif -%}
{%- endfor %}

/usr/local/bin/find_unchanged.py:
  file:
    - managed
    - source: salt://carbon/find_unchanged.py
    - mode: 551
    - user: root
    - group: root
    - require:
      - file: /usr/local
      - module: pysc

/etc/cron.daily/graphite_find_unchanged_data:
  file:
    - managed
    - mode: 500
    - user: root
    - group: root
    - contents: |
        #!/bin/bash
        /usr/local/bin/find_unchanged.py --days 10 --delete /var/lib/graphite/whisper/*
    - require:
      - service: cron
      - file: /usr/local/bin/find_unchanged.py

/etc/graphite/storage-aggregation.conf:
  file:
    - managed
    - mode: 440
    - user: root
    - group: graphite
    - replace: False
    - require:
      - file: /etc/graphite
      - user: graphite
