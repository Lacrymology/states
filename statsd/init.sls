{#
 Install PyStatsD daemon, a statsd nodejs equivalent in python
 #}
include:
  - virtualenv
  - gsyslog
  - local

/var/log/statsd.log:
  file:
    - absent

statsd:
  file:
    - managed
    - name: /etc/init/statsd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://statsd/upstart.jinja2
  virtualenv:
    - manage
    - name: /usr/local/statsd
    - require:
      - module: virtualenv
      - file: /usr/local
  service:
    - running
    - enable: True
    - require:
      - service: gsyslog
    - watch:
      - file: statsd
      - virtualenv: statsd
  module:
    - wait
    - name: pip.install
    - requirements: /usr/local/statsd/salt-requirements.txt
    - bin_env: /usr/local/statsd
    - require:
      - virtualenv: statsd
    - watch:
      - pkg: python-dev
      - file: statsd_requirements

statsd_requirements:
  file:
    - managed
    - name: /usr/local/statsd/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://statsd/requirements.jinja2
    - require:
      - virtualenv: statsd
