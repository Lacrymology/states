{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - backup.client.base.nrpe.absent

backup_client_nrpe-requirements:
  file:
    - absent
    - name: /usr/local/nagios/backup.client.scp.nrpe-requirements.txt

{# remove file with bad name #}
/usr/local/nagios/backup.client.nrpe-requirements.txt:
  file:
    - absent
