{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
include:
  - dovecot
  - fail2ban

dovecot_jail:
  fail2ban:
    - enabled
    - name: dovecot
    - port:
      - smtp
      - ssmtp
      - submission
      - imap2
      - imap3
      - imaps
      - pop3
      - pop3s
    - logpath: /var/log/syslog
    - require:
      - cmd: fail2ban
    - require_in:
      - service: fail2ban
