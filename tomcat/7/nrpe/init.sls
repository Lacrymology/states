{#
 Nagios NRPE check for Tomcat7
#}
include:
  - nrpe
  - apt.nrpe
  - rsyslog.nrpe

/etc/nagios/nrpe.d/tomcat.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://tomcat/7/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/tomcat.cfg
