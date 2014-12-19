{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- set filter_type = salt['pillar.get']('carbon:filter:type', None) -%}
{%- set supported_filter_types = ('white', 'black')  %}

include:
  - cron
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
    - user: graphite
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
    - user: graphite
    - group: graphite
    - mode: 440
    - source: salt://carbon/storage.jinja2
    - require:
      - user: graphite
      - file: /etc/graphite

stop_old_instance:
  service:
    - name: carbon-a
    - dead
    - enable: False
  file:
    - name: /etc/init.d/carbon-a
    - absent
    - require:
      - service: stop_old_instance
  cmd:
    - run
    - name: mv /var/lib/graphite/whisper/ /var/lib/graphite/old
    - onlyif: test -d /var/lib/graphite/whisper/carbon
    - user: graphite
    - group: graphite
    - require:
      - file: stop_old_instance
    - require_in:
      - file: /var/lib/graphite/whisper

move_old_data_to_first_instance:
  cmd:
    - run
    - name: mv /var/lib/graphite/old /var/lib/graphite/whisper/0
    - onlyif: test -d /var/lib/graphite/old
    - require:
      - file: /var/lib/graphite/whisper/0
      - cmd: stop_old_instance
    - require_in:
      - file: carbon

carbon:
  file:
    - managed
    - name: /usr/local/graphite/salt-carbon-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://carbon/requirements.jinja2
    - require:
      - virtualenv: graphite
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/graphite/bin/pip
    - requirements: /usr/local/graphite/salt-carbon-requirements.txt
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
    - user: graphite
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
    - user: graphite
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
    - user: graphite
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
