{#-
Nagios NRPE check for OpenERP
#}

include:
  - nrpe
  - apt.nrpe
  - nginx.nrpe
  - pip.nrpe
  - postgresql.server.nrpe
  - underscore.nrpe

/etc/nagios/nrpe.d/openerp-server.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://openerp/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/openerp-server.cfg
