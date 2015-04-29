{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/cron.daily/backup-mysql:
  file:
    - absent

/usr/local/bin/backup-mysql:
  file:
    - absent

/usr/local/bin/backup-mysql-all:
  file:
    - absent
