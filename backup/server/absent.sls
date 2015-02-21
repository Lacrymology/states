{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/var/lib/backup:
  file:
    - absent

/etc/cron.weekly/backup-archiver:
  file:
    - absent

{{ opts['cachedir'] }}/pip/backup.server:
  file:
    - absent
