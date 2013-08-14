{#
 Nagios NRPE check for Carbon
#}
include:
  - graphite.common.nrpe
  - nrpe
  - pip.nrpe
  - logrotate.nrpe
  - python.dev.nrpe

/etc/nagios/nrpe.d/carbon.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://carbon/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/carbon.cfg
