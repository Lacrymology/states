{#
 Nagios NRPE check for Dovecot
#}
include:
  - nrpe
  - apt.nrpe

/etc/nagios/nrpe.d/dovecot.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://dovecot/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/dovecot.cfg
