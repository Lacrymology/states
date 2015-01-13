{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
/etc/cron.daily/backup-postgresql:
  file:
    - absent

/usr/local/bin/backup-postgresql:
  file:
    - absent

/usr/local/bin/backup-postgresql-all:
  file:
    - absent

/usr/local/bin/backup-postgresql-by-role:
  file:
    - absent
