{#
 Nagios NRPE checks for diamond
#}
include:
  - nrpe
  - nrpe.diamond
  - git.nrpe
  - python.dev.nrpe
  - virtualenv.nrpe
  - rsyslog.nrpe

/etc/nagios/nrpe.d/diamond.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://diamond/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/diamond.cfg
