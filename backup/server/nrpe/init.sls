{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
  Nagios NRPE check for Backup Server
-#}
include:
  - nrpe
  - sudo
  - sudo.nrpe
  - apt.nrpe
  - ssh.server.nrpe
  - pip.nrpe
  - cron.nrpe
  - rsyslog.nrpe

/usr/local/bin/check_backups.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_backups.py:
  file:
    - managed
    - user: root
    - group: root
    - mode: 550
    - source: salt://backup/server/nrpe/check.py
    - require:
      - pkg: nagios-nrpe-server

/etc/sudoers.d/nrpe_backups:
  file:
    - managed
    - source: salt://backup/server/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

/etc/nagios/nrpe.d/backups.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://backup/server/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
      - file: /etc/sudoers.d/nrpe_backups
      - file: /usr/lib/nagios/plugins/check_backups.py

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/backups.cfg
