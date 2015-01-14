{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
include:
  - fail2ban
  - proftpd

proftpd_jail:
  fail2ban:
    - enabled
    - name: proftpd
    - port:
      - ftp
      - ftp-data
      - ftps
      - ftps-data
    - logpath: /var/log/syslog
    - require:
      - cmd: fail2ban
    - require_in:
      - service: fail2ban
