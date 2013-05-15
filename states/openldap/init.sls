slapd:
  pkg:
    - installed
    - pkgs:
      - slapd
      - ldap-utils
  service:
    - running
    - enable: False
    - require: 
      - pkg: slapd

/tmp/dbconfig.ldif:
  file:
    - managed
    - source: salt://openldap/dbconfig.ldif

slapd_change_root_dn:
  cmd:
    - run
    - name: 'ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/dbconfig.ldif'
    - require:
      - file: /tmp/dbconfig.ldif
      - service: slapd

/tmp/logging.ldif:
  file:
    - managed
    - source: salt://openldap/logging.ldif

slapd_change_log_level:
  cmd:
    - wait
    - name: 'ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/logging.ldif'
    - unless: 'grep "olcLogLevel: 16383" /etc/ldap/slapd.d/cn=config.ldif'
    - watch:
      - cmd: slapd_change_root_dn
    - require:
      - file: /tmp/logging.ldif
      - service: slapd

openldap:
  user:
    - present
    - groups:
      - openldap
      - ssl-cert
    - require:
      - pkg: slapd

/etc/ssl/private/ldap.pem:
  file:
    - managed
    - source: salt://openldap/serverkey.pem
    - user: openldap
    - group: openldap
    - mode: 640
    - makedirs: true

/etc/ssl/certs/ldap.pem:
  file:
    - managed
    - source: salt://openldap/servercrt.pem
    - user: openldap
    - group: openldap
    - makedirs: true

/etc/ssl/certs/ldapca.pem:
  file:
    - managed
    - source: salt://openldap/cacert.pem
    - user: openldap
    - group: openldap
    - makedirs: true

/tmp/tls.ldif:
  file:
    - managed
    - source: salt://openldap/tls.ldif

slapd_set_tls_directives:
  cmd:
    - run
    - name: 'ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/tls.ldif'
    - require:
      - service: slapd
      - file: /tmp/tls.ldif
{# Cert/key must be created use GNUTLS
openssl is not compatible with ubuntu ldap #}
      - file: /etc/ssl/private/ldap.pem
      - file: /etc/ssl/certs/ldap.pem
      - file: /etc/ssl/certs/ldapca.pem
      - user: openldap

/etc/ldap/ldap.conf:
  file:
    - managed
    - source: salt://openldap/ldap.conf
