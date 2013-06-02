{% set ssl = salt['pillar.get']('dovecot:ssl', False) %}
include:
  - dovecot.agent
  - apt
  - postfix
{% if ssl %}
  - ssl
{% endif %}

dovecot:
  pkg:
    - installed
    - pkgs:
      - dovecot-imapd
      - dovecot-pop3d
      - dovecot-ldap
    - require:
      - cmd: apt_sources
      - pkg: postfix
  service:
    - running
    - watch:
      - file: /etc/dovecot/conf.d/99-all.conf
      - pkg: dovecot
      - file: /etc/dovecot/dovecot-ldap.conf.ext
      - file: /var/mail/vhosts/indexes
    - require:
      - user: dovecot-agent

/etc/dovecot/conf.d/:
  file:
    - directory
    - clean: True
    - user: dovecot
    - group: dovecot
    - dir_mode: 700
    - require:
      - file: /etc/dovecot/conf.d/99-all.conf
      - pkg: dovecot

/etc/dovecot/conf.d/99-all.conf:
  file:
    - managed
    - source: salt://dovecot/99-all.jinja2
    - template: jinja
    - mode: 400
    - user: dovecot
    - group: dovecot
    - require:
      - pkg: dovecot

/etc/dovecot/dovecot-ldap.conf.ext:
  file:
    - managed
    - source: salt://dovecot/ldap.jinja2
    - mode: 400
    - template: jinja
    - user: dovecot
    - group: dovecot
    - require:
      - pkg: dovecot

/var/mail/vhosts/indexes:
  file:
    - directory
    - user: dovecot-agent
    - makedirs: True
    - require:
      - user: dovecot-agent

{% if ssl %}
extend:
  dovecot:
    service:
      - watch:
        - cmd: /etc/ssl/{{ pillar['dovecot']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['dovecot']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['dovecot']['ssl'] }}/ca.crt
{% endif %}
