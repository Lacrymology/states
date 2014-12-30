{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
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

salt-archive-clamav:
  file:
    - absent
    - name: /usr/local/bin/salt_archive_clamav.py

/usr/local/bin/salt_archive_clamav.sh:
  file:
    - absent

{{ opts['cachedir'] }}/sync_timestamp.dat:
  file:
    - absent

/var/cache/salt/master/sync_timestamp.dat:
  file:
    - absent
