{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Luan Vo Ngoc <luan@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
cleanup-old-archive:
  file:
    - absent
    - name: /etc/cron.daily/backup-server-ssh

/etc/cron.daily/cleanup-old-archive:
  file:
    - absent
