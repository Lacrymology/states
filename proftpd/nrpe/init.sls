{#
 Nagios NRPE check for ProFTPd
#}
include:
  - nrpe
  - apt.nrpe
  - postgresql.server.nrpe

/etc/nagios/nrpe.d/proftpd.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://proftpd/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/proftpd.cfg
