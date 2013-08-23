{#-
Carbon Daemon
=============

Install Carbon, daemon that store on disk statistics database used by Graphite
to render graphics.

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.

graphite:
  carbon:
    instances: 2
  retentions:
    - three_month:
      name: default_1min_for_1_month
      pattern: .*
      retentions: 60s:30d

graphite:carbon:instances: number of instances to deploy, should <= numbers of CPU cores
graphite:retentions: list of data retention rules, see the following for
    details:
    http://graphite.readthedocs.org/en/latest/config-carbon.html#storage-schemas-conf

Optional Pillar
---------------

graphite:
  file-max: 65535
  carbon:
    replication: 1
    interface: 0.0.0.0
shinken_pollers:
  - 192.168.1.1

graphite:file-max: maximum of open files for the daemon. Default: not used.
graphite:carbon:interface: Network interface to bind Carbon-relay daemon.
    Default: 0.0.0.0.
graphite:carbon:replication: add redundancy of your data by replicating
    every data point and relaying it to N caches (0 < N <= number of cache instances).
    Default: 1 (Mean you have only one copy for each metric = No replication)
shinken_pollers: IP address of monitoring poller that check this server.
    Default: not used.
-#}

{#- TODO: send logs to GELF -#}
include:
  - graphite.common
  - pip
  - logrotate
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

{% if 'file-max' in pillar['graphite'] %}
fs.file-max:
  sysctl:
    - present
    - value: {{ pillar['graphite']['file-max'] }}
{% endif %}

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
    - require:
      - file: /etc/graphite

{%- set instances_count = pillar['graphite']['carbon']['instances'] %}

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
      - file: /var/lib/graphite
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
      - user: graphite
      - file: /var/log/graphite/carbon
      - file: /var/lib/graphite
    - watch:
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
