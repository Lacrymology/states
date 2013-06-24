/etc/nginx/conf.d/salt_archive.conf:
  file:
    - absent

/etc/cron.hourly/salt_archive:
  file:
    - absent

/usr/local/bin/salt_archive_incoming.py:
  file:
    - absent
  cron:
    - absent
    - user: root
