{#
 Nagios NRPE check for StatsD
#}
include:
  - nrpe
  - virtualenv.nrpe
  - rsyslog.nrpe

/etc/nagios/nrpe.d/statsd.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://statsd/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/statsd.cfg
