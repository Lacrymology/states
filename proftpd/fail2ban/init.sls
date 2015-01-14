{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - fail2ban
  - proftpd

proftpd_jail:
  fail2ban:
    - enabled
    - name: proftpd
    - ports:
      - ftp
      - ftp-data
      - ftps
      - ftps-data
    - logpath: /var/log/syslog
    - require:
      - cmd: fail2ban
    - require_in:
      - service: fail2ban
