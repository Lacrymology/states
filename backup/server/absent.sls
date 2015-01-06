{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
/var/lib/backup:
  file:
    - absent

/etc/cron.weekly/backup-archiver:
  file:
    - absent

{{ opts['cachedir'] }}/pip/backup.server:
  file:
    - absent
