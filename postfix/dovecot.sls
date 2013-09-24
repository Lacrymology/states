include:
  - dovecot.agent
  - postfix

/var/mail/vhosts:
  file:
    - directory
    - user: dovecot-agent
    - require:
      - user: dovecot-agent
    - require_in:
      - service: postfix
