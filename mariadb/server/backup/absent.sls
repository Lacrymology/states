{#
 Remove Backup client for MariaDB/MySQL
 #}
/etc/cron.daily/backup-mysql:
  file:
    - absent

/usr/local/bin/backup-mysql:
  file:
    - absent

/usr/local/bin/backup-mysql-all:
  file:
    - absent
