{#
 Nagios NRPE checks for bigbluebutton
 #}
include:
  - nrpe
  - nginx.nrpe
  - redis.nrpe
  - tomcat.nrpe

/etc/nagios/nrpe.d/bigbluebutton.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://bigbluebutton/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/bigbluebutton.cfg
