{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - backup.client.base.nrpe.absent

/etc/nagios/s3lite.yml:
  file:
    - absent

/usr/lib/nagios/plugins/check_backup_s3lite.py:
  file:
    - absent
