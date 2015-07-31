{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - fail2ban
  - xinetd

xinetd_jail:
  fail2ban:
    - enabled
    - name: xinetd
    - filter: xinetd-fail
    - ports:
      - all
    - logpath: /var/log/syslog
    - require:
      - cmd: fail2ban
    - require_in:
      - service: fail2ban
