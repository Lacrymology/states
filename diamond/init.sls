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
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - pkgs: ''
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-requirements.txt
    - require:
      - pkg: git
      - virtualenv: diamond
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
      - file: /etc/diamond
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
