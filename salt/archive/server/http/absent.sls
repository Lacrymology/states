/etc/nginx/conf.d/salt_archive.conf:
  file:
    - absent

/etc/cron.hourly/salt_archive:
  file:
    - absent
