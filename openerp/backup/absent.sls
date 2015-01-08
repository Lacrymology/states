{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Luan Vo Ngoc <luan@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
backup-openerp:
  file:
    - absent
    - name: /etc/cron.daily/backup-openerp
