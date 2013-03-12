include:
  - virtualenv
  - nrpe
  - diamond

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
      - pkg: python-virtualenv
  service:
    - running
    - enable: True
    - watch:
      - file: statsd
      - virtualenv: statsd

statsd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[statsd]]
        cmdline = ^\/usr\/local\/statsd\/bin\/python \/usr\/local\/statsd\/bin\/pystatsd\-server

/etc/nagios/nrpe.d/statsd.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://statsd/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/statsd.cfg
