{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - fail2ban
  - postfix

postfix_jail:
  fail2ban:
    - enabled
    - name: postfix
    - ports:
      - smtp
      - ssmtp
      - submission
    - logpath: /var/log/syslog
    - require:
      - cmd: fail2ban
    - require_in:
      - service: fail2ban
