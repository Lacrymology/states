{#
 Nagios NRPE check for ClamAV
#}
include:
  - nrpe
  - apt.nrpe

/etc/nagios/nrpe.d/clamav.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://clamav/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/clamav.cfg
