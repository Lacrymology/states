{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
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

cron_sendmail_patch:
  cmd:
    - wait
    - name: perl -pi -e "s|/usr/sbin/ravenmail|/usr/bin/sendmail|" /usr/sbin/cron
    - unless: grep -a sendmail /usr/sbin/cron
    - watch:
      - file: /usr/bin/mail
