/var/mail/vhosts/indexes:
  file:
    - absent

dovecot:
  pkg:
    - purged
    - pkgs:
      - dovecot-imapd
      - dovecot-pop3d
      - dovecot-ldap
      - dovecot-core
  file:
    - absent
    - name: /etc/dovecot
    - require:
      - pkg: dovecot
