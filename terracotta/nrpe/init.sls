{#
 Nagios NRPE check for terracotta
#}
include:
  - nrpe
  - apt.nrpe

/etc/nagios/nrpe.d/terracotta.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://terracotta/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/terracotta.cfg
