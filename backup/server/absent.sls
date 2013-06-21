{#
 Remove poor man backup server
#}
/var/lib/backup:
  file:
    - absent

/etc/backup-archive.conf:
  file:
    - absent

/etc/cron.weekly/backup-archiver:
  file:
    - absent

{{ opts['cachedir'] }}/backup-requirements.txt:
  file:
    - absent
