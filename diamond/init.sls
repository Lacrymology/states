{#-
Diamond
=======

Install diamond, a daemon and toolset for gather system statistics
and publishing them to graphite.

Mostly operating system related such as CPU, memory.

but it's often plug with third party daemon such as PostgreSQL to gather
those stats as well.
Each of those other daemons state come with their own configuration file
that are put in /etc/diamond/collectors, directory check at startup for
additional configurations.

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.
graphite_address: IP/Hostname of carbon/graphite server.

Optional Pillar
---------------

diamond:
  interfaces:
    - eth0
    - lo
  ping:
    - 192.168.1.1
    - 192.168.1.2
shinken_pollers:
  - 192.168.1.1
graylog2_address: 192.168.1.1

diamond:interfaces: list of network interface check for I/O stats.
    default show in example.
diamond:ping: list of IP/hostname ping to monitor latency and availability.
graylog2_address: IP/Hostname of centralized Graylog2 server
shinken_pollers: IP address of monitoring poller that check this server.
-#}
{#- TODO: sentry/raven integration -#}
include:
  - git
  - python.dev
  - local
  - virtualenv
  - gsyslog
  - gsyslog.diamond
{% if 'shinken_pollers' in pillar %}
  - diamond.nrpe
{% endif %}

/etc/diamond:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

/etc/diamond/collectors:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550
    - require:
      - file: /etc/diamond

diamond_upstart:
  file:
    - managed
    - name: /etc/init/diamond.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/upstart.jinja2
    - require:
      - module: diamond

diamond_requirements:
  file:
    - managed
    - name: /usr/local/diamond/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/requirements.jinja2
    - require:
      - virtualenv: diamond

/etc/diamond/collectors/ProcessMemoryCollector.conf:
  file:
    - absent

diamond:
  virtualenv:
    - manage
    - upgrade: True
    - name: /usr/local/diamond
    - require:
      - module: virtualenv
      - file: /usr/local
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-requirements.txt
    - require:
      - pkg: git
      - virtualenv: diamond
    - watch:
      - pkg: python-dev
      - file: diamond_requirements
  file:
    - managed
    - name: /etc/diamond/diamond.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/config.jinja2
    - require:
      - file: /etc/diamond
{%- for host in salt['pillar.get']('diamond:ping', []) -%}
    {%- if loop.first %}
    - context:
      ping_hosts:
    {%- endif %}
        {{ host }}: {{ pillar['diamond']['ping'][host] }}
{%- endfor %}
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - service: gsyslog
    - watch:
      - virtualenv: diamond
      - file: diamond
      - file: diamond_upstart
      - module: diamond
      - cmd: diamond
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
  cmd:
    - wait
    - name: find /usr/local/diamond -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: diamond

/etc/diamond/collectors/ProcessResourcesCollector.conf:
  file:
    - managed
    - template: jinja
    - source: salt://diamond/ProcessResourcesCollector.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/diamond/collectors
      - file: /etc/diamond/collectors/ProcessMemoryCollector.conf
