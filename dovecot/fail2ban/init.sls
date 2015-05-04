{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - dovecot
  - fail2ban

dovecot_jail:
  fail2ban:
    - enabled
    - name: dovecot
    - ports:
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
