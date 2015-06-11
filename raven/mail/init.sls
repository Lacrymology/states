{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - pysc
  - raven
  - rsyslog
  - cron
  - requests

/usr/bin/mail:
  file:
    - managed
    - user: root
    - group: root
    - mode: 775
    - follow_symlinks: False
    - source: salt://raven/mail/script.py
    - require:
      - module: raven
      - service: rsyslog
      - module: pysc
      - module: requests

/usr/bin/ravenmail:
  file:
    - symlink
    - target: /usr/bin/mail
    - require:
      - file: /usr/bin/mail

cron_sendmail_patch:
  cmd:
    - run
    - name: perl -pi -e "s|/usr/sbin/sendmail|/usr/bin/ravenmail|" /usr/sbin/cron
    - unless: grep -a ravenmail /usr/sbin/cron
    - require:
      - pkg: cron
      - file: /usr/bin/ravenmail
    - watch_in:
      - service: cron
