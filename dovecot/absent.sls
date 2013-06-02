{% set ssl = salt['pillar.get']('dovecot:ssl', False) %}

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

/etc/dovecot/:
  file:
    - absent
    - require:
      - pkg: dovecot


/etc/ssl/{{ pillar['dovecot']['ssl'] }}:
  file:
    - absent
