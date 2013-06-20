{#-
Dovecot: A POP3/IMAP server
=============================

Mandatory Pillar
----------------

ldap:
  suffix: Domain component entry # Example: dc=example,dc=com

Optional Pillar
---------------

ldap:
  host: ldap://127.0.0.1

ldap:host: LDAP URIs that be used for authentication

-#}
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
{% if ssl %}
      - cmd: /etc/ssl/{{ ssl }}/chained_ca.crt
      - module: /etc/ssl/{{ ssl }}/server.pem
      - file: /etc/ssl/{{ ssl }}/ca.crt
{% endif %}
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
      - user: dovecot-agent

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
