{#
 Nagios NRPE check for Backup Server
#}
include:
  - nrpe
  - sudo

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

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/backups.cfg
