{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
/etc/nginx/conf.d/salt_archive.conf:
  file:
    - absent

{#- old version of states #}
/etc/cron.hourly/salt_archive:
  file:
    - absent

/usr/local/bin/salt_archive_incoming.py:
  file:
    - absent

/etc/cron.d/salt-archive:
  file:
    - absent
