{% set cfgfiles = ('10-auth.conf','10-mail.conf','10-master.conf') %}
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
      {% for i in cfgfiles %}
      - file: /etc/dovecot/conf.d/{{ i }}
      {% endfor %}
    - require:
      - user: dovecot-agent

{% for i in cfgfiles %}
/etc/dovecot/conf.d/{{ i }}:
  file:
    - managed
    - source: salt://dovecot/{{ i }}.jinja2
    - mode: 644
    - user: root
    - group: root
{% endfor %}

dovecot-agent:
  user:
    - present
    - uid: 4000
    - groups:
      - mail

/var/mail/vhosts/indexes:
  file:
    - directory
    - user: dovecot-agent
    - makedirs: True
    - require:
      - user: dovecot-agent

/etc/dovecot/dovecot-ldap.conf.ext:
  file:
    - managed
    - source: salt://dovecot/dovecot-ldap.conf.ext.jinja2
    - mode: 600
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
