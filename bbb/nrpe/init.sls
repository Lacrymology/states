{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Nagios NRPE checks for bigbluebutton
 -#}
include:
  - nrpe
  - nginx.nrpe
  - redis.nrpe
  - tomcat.6.nrpe

/etc/nagios/nrpe.d/bigbluebutton.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://bbb/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/bigbluebutton.cfg
