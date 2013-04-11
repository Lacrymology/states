{#
 Install diamond, a daemon and toolset for gather system statistics
 and publishing them to graphite.

 Mostly operating system related such as CPU, memory.

 but it's often plug with third party daemon such as PostgreSQL to gather
 those stats as well.
 Each of those other daemons state come with their own configuration file
 that are put in /etc/diamond/collectors, directory check at startup for
 additional configurations.
#}
include:
  - git
  - virtualenv
  - nrpe

/etc/diamond/collectors:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550
    - require:
      - file: diamond

diamond_upstart:
  file:
    - managed
    - name: /etc/init/diamond.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/upstart.jinja2

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
      - pkg: python-virtualenv
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - pkgs: ''
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-requirements.txt
    - require:
      - pkg: git
      - pkg: python-virtualenv
      - file: diamond_upstart
    - watch:
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
      - virtualenv: diamond
{% if 'ping' in pillar['diamond']|default([]) %}
    - context:
      ping_hosts: {{ pillar['diamond']['ping'] }}
{% endif %}
  service:
    - running
    - enable: True
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

/etc/nagios/nrpe.d/diamond.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://diamond/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/diamond.cfg
