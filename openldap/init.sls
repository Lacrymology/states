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
    - watch:
      - pkg: slapd
  file:
    - managed
    - name: /etc/ldap/ldap.conf
    - source: salt://openldap/ldap.jinja2
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
