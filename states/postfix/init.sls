postfix:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: postfix
      - file: /etc/postfix/master.cf
    - require:
      - pkg: postfix
  file:
    - managed
    - name: /etc/postfix/main.cf
    - source: salt://postfix/main.cf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix

/etc/postfix/master.cf:
  file:
    - managed
    - source: salt://postfix/master.cf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix

postfix-ldap:
  pkg:
    - installed


/var/mail/vhosts:
  file:
    - directory
    - user: dovecot-agent
    - makedirs: True

/etc/ssl/certs/postfix.pem:
  file:
    - managed
    - source: salt://dovecot/cert.pem
    - mode: 644
    - user: root
    - group: root

/etc/ssl/private/postfix.pem:
  file:
    - managed
    - source: salt://dovecot/key.pem
    - mode: 600
    - user: root
    - group: root
