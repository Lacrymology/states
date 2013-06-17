postfix:
  pkg:
    - purged

postfix-ldap:
  pkg:
    - purged

/var/mail/vhosts:
  file:
    - absent

/etc/postfix:
  file:
    - absent
    - require:
      - pkg: postfix
