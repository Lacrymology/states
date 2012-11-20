include:
  - virtualenv
  - nrpe

/etc/nagios/nrpe.d/statsd.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://statsd/nrpe.jinja2

statsd:
  file:
    - managed
    - name: /etc/init/statsd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://statsd/upstart.jinja2
  virtualenv:
    - manage
    - name: /usr/local/statsd
    - requirements: salt://statsd/requirements.txt
    - require:
      - pkg: python-virtualenv
  service:
    - running
    - watch:
      - file: statsd
      - virtualenv: statsd

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/statsd.cfg
