{#
 Nagios NRPE check for MongoDB
#}
include:
  - nrpe
  - apt.nrpe
  - logrotate.nrpe

/etc/nagios/nrpe.d/mongodb.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://mongodb/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/mongodb.cfg
