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
    - source: salt://postfix/main.cf.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix

/etc/postfix/master.cf:
  file:
    - managed
    - source: salt://postfix/master.cf.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix

/etc/mailname:
  file:
    - managed
    - source: salt://postfix/mailname.jinja2
    - template: jinja

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

/etc/postfix/vmailbox:
  file:
    - managed
    - source: salt://postfix/vmailbox

postmap /etc/postfix/vmailbox:
  cmd:
    - run
    - require:
      - file: /etc/postfix/vmailbox
      - pkg: postfix

