{#
 Install PyStatsD daemon, a statsd nodejs equivalent in python
 #}
include:
  - virtualenv

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
    - template: jinja
    - requirements: salt://statsd/requirements.jinja2
    - require:
      - module: virtualenv
  service:
    - running
    - enable: True
    - watch:
      - file: statsd
      - virtualenv: statsd
