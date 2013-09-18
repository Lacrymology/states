{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com

 Nagios NRPE checks for MariaDB
-#}
include:
  - nrpe
  - apt.nrpe
  - mariadb.nrpe
  - salt.minion.nrpe

/etc/nagios/nrpe.d/mysql.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://mariadb/server/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/mysql.cfg
