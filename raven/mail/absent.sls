{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/usr/bin/mail:
  file:
    - symlink
    - target: /etc/alternatives/mail
    - force: True
    - user: root
    - group: root
    - mode: 775

/usr/bin/ravenmail:
  file:
    - absent

cron_sendmail_unpatch:
  cmd:
    - wait
    - name: perl -pi -e "s|/usr/bin/ravenmail|/usr/sbin/sendmail|" /usr/sbin/cron
    - unless: grep -a sendmail /usr/sbin/cron
    - watch:
      - file: /usr/bin/mail
