{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 Nagios NRPE check for Denyhosts
-#}
include:
  - nrpe
  - apt.nrpe
  - rsyslog.nrpe
  - denyhosts

/etc/nagios/nrpe.d/denyhosts.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://denyhosts/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/denyhosts.cfg
