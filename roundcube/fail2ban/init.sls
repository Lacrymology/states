{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - fail2ban
  - roundcube

roundcube_jail:
  fail2ban:
    - enabled
    - name: roundcube
    - filter: roundcube-auth
    - ports:
      - http
      - https
    - logpath: /var/log/syslog
    - require:
      - cmd: fail2ban
    - require_in:
      - service: fail2ban
