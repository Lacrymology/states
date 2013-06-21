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
    instances:
      - a
  retentions:
    - three_month:
      name: default_1min_for_1_month
      pattern: .*
      retentions: 60s:30d

graphite:carbon:instances: list of instance to deploy. (leave 'a')
graphite:retentions: list of data retention rules, see the following for
    details:
    http://graphite.readthedocs.org/en/latest/config-carbon.html#storage-schemas-conf

Optional Pillar
---------------

graphite:
  file-max: 65535
  carbon:
    interface: 0.0.0.0
shinken_pollers:
  - 192.168.1.1

graphite:file-max: maximum of open files for the daemon. Default: not used.
graphite:carbon:interface: Network interface to bind the Carbon daemon.
    Default: 0.0.0.0.
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
{%- if 'files_archive' in pillar %}
    - no_index: True
    - find_links: {{ pillar['files_archive'] }}/pip/
{%- endif %}
    - upgrade: True
    - bin_env: /usr/local/graphite/bin/pip
    - requirements: /usr/local/graphite/salt-carbon-requirements.txt
    - install_options:
      - "--prefix=/usr/local/graphite"
      - "--install-lib=/usr/local/graphite/lib/python2.7/site-packages"
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

{% for instance in pillar['graphite']['carbon']['instances'] %}
carbon-{{ instance }}:
  file:
    - managed
    - name: /etc/init.d/carbon-{{ instance }}
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://carbon/init.jinja2
    - context:
      instance: a
  service:
    - running
    - enable: True
{# until https://github.com/saltstack/salt/issues/5027 is fixed, this is required #}
    - sig: /usr/local/graphite/bin/python /usr/local/graphite/bin/carbon-cache.py --config=/etc/graphite/carbon.conf --instance={{ instance }} start
    - name: carbon-{{ instance }}
    - require:
      - user: graphite
      - file: /var/log/graphite/carbon
      - file: /var/lib/graphite
      - file: carbon-{{ instance }}-logdir
    - watch:
      - module: carbon
      - cmd: carbon
      - file: /etc/graphite/carbon.conf
      - file: /etc/graphite/storage-schemas.conf
      - file: carbon-{{ instance }}
      - cmd: carbon

carbon-{{ instance }}-logdir:
  file:
    - directory
    - name: /var/log/graphite/carbon/carbon-cache-{{ instance }}
    - user: graphite
    - group: graphite
    - mode: 770
    - makedirs: True
    - require:
      - user: graphite
      - file: /var/log/graphite/carbon
{% endfor %}
