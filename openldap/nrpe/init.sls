{#
 Nagios NRPE check for OpenLDAP
#}
include:
  - nrpe
  - apt.nrpe

/etc/nagios/nrpe.d/openldap.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://openldap/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/openldap.cfg
