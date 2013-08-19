{#-
OpenLDAP: A LDAP server
=============================

Mandatory Pillar
----------------

ldap:
  suffix: Domain component entry # Example: dc=example,dc=com
  usertree: salt path to user tree LDIF file # Example: user_stuff/ldaptree.ldif
  rootdn: Root Distinguished Name # Example: dn=admin,dc=example,dc=com
  rootpw: Root's password (can be created used ldappasswd)

ldap:usertree: If use `openldap/usertree.ldif.jinja2`, data from ldap:data will be used for creating LDAP users

Optional Pillar
---------------

ldap:
  log_level: 256
  data:
    mailname:
      user1:
        cn: CN user1
        sn: SN user1
        passwd: password of user1 (plaintext or created by ldappasswd)
        desc: description for user1
        email: other email of user1
      user2:
        cn: CN user2
        sn: SN user2
        passwd: password of user2
        desc:
        email:

ldap:data: nested dict contain user infomation, that will be used for create LDAP users and mapping emails (user@mailname) to mailboxes
ldap:log_level: log verbose level, some values of this can be: -1, 256, 16383, ...
-#}
{% set ssl = salt['pillar.get']('ldap:ssl', False) %}
include:
  - apt
{% if ssl %}
  - ssl
{% endif %}

slapd:
  pkg:
    - latest
    - pkgs:
      - slapd
      - ldap-utils
    - require:
      - cmd: apt_sources
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - pkg: slapd
  file:
    - managed
    - name: /etc/ldap/ldap.conf
    - source: salt://openldap/config.jinja2
    - template: jinja

{% if ssl %}
openldap:
  user:
    - present
    - groups:
      - ssl-cert
      - openldap
    - require:
      - pkg: slapd
      - pkg: ssl-cert
{% endif %}

/tmp/tls.ldif:
  file:
    - absent

/tmp/logging.ldif:
  file:
    - absent

{{ opts['cachedir'] }}/dbconfig.ldif:
  file:
    - managed
    - source: salt://openldap/dbconfig.ldif.jinja2
    - template: jinja
    - mode: 400

slapd_config_dbs:
  cmd:
    - wait
    - watch:
      - pkg: slapd
    - name: 'ldapmodify -Y EXTERNAL -H ldapi:/// -f {{ opts['cachedir'] }}/dbconfig.ldif'
    - require:
      - file: {{ opts['cachedir'] }}/dbconfig.ldif
      - service: slapd
{% if ssl %}
{# Cert/key must be created use GNUTLS
openssl is not compatible with ubuntu ldap #}
      - cmd: /etc/ssl/{{ ssl }}/chained_ca.crt
      - module: /etc/ssl/{{ ssl }}/server.pem
      - file: /etc/ssl/{{ ssl }}/ca.crt
      - user: openldap

restart_after_ssl:
  cmd:
    - wait
    - name: service slapd restart
    - watch:
      - cmd: slapd_config_dbs
{% endif %}

{% if salt['pillar.get']('ldap:usertree') %}
{{ opts['cachedir'] }}/usertree.ldif:
  file:
    - managed
    - template: jinja
    - source: salt://{{ salt['pillar.get']('ldap:usertree') }}
    - mode: 400

ldapadd -Y EXTERNAL -H ldapi:/// -f {{ opts['cachedir'] }}/usertree.ldif:
  cmd:
    - wait
    - watch:
      - pkg: slapd
    - require:
      - file: {{ opts['cachedir'] }}/usertree.ldif
      - service: slapd
      - cmd: slapd_config_dbs
{% endif %}
