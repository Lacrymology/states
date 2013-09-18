{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
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
