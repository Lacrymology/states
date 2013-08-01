{#
 Nagios NRPE check for OpenSSH Server
#}
include:
  - nrpe
  - apt.nrpe
  - rsyslog.nrpe

/etc/nagios/nrpe.d/ssh.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://ssh/server/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/ssh.cfg
