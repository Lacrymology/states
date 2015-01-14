{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - fail2ban
  - mysql.server

mysql_jail:
  fail2ban:
    - enabled
    - name: mysql
    - filter: mysqld-auth
    - ports:
      - 3306
    - logpath: /var/log/syslog
    - require:
      - cmd: fail2ban
    - require_in:
      - service: fail2ban
