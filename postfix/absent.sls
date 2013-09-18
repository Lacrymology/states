{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
postfix:
  pkg:
    - purged
    - pkgs:
      - postfix
      - postfix-ldap

/var/mail/vhosts:
  file:
    - absent

/etc/postfix:
  file:
    - absent
    - require:
      - pkg: postfix
