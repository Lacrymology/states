{#
 Nagios NRPE check for Amavis
#}
include:
  - nrpe
  - apt.nrpe

/etc/nagios/nrpe.d/amavis.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://amavis/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/amavis.cfg
