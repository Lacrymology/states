{#
 Nagios NRPE check for Gsyslog
#}
include:
  - nrpe
  - virtualenv.nrpe
  - pip.nrpe
  - apt.nrpe
  - python.dev.nrpe

/etc/nagios/nrpe.d/gsyslog.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://gsyslog/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/gsyslog.cfg
