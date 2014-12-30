{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Luan Vo Ngoc <luan@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Turn off backup for Salt Master.
-#}
backup-saltmaster:
  file:
    - absent
    - name: /etc/cron.daily/backup-saltmaster
