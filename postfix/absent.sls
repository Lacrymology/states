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
