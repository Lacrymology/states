dovecot:
  pkg:
    - installed
    - pkgs:
      - dovecot-imapd
      - dovecot-pop3d
      - dovecot-ldap
  service:
    - running
    - enable: False
    - watch:
      - file: /etc/dovecot/conf.d/10-mail.conf

/etc/dovecot/conf.d/10-mail.conf:
  file:
    - managed
    - source: salt://dovecot/10-mail.jinja2
    - mode: 644
    - user: root
    - group: root

/etc/ssl/certs/dovecot.pem:
  file:
    - managed
    - source: salt://dovecot/cert.pem
    - mode: 644
    - user: root
    - group: root

/etc/ssl/private/dovecot.pem:
  file:
    - managed
    - source: salt://dovecot/key.pem
    - mode: 600
    - user: root
    - group: root
