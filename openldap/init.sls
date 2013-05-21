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

/etc/ldap/dbconfig.ldif:
  file:
    - managed
    - source: salt://openldap/dbconfig.ldif
    - mode: 600

openldap:
  user:
    - present
    - groups:
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
    - absent

/tmp/logging.ldif:
  file:
    - absent

slapd_config_dbs:
  cmd:
    - run
    - name: 'ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/dbconfig.ldif'
    - require:
      - file: /etc/ldap/dbconfig.ldif
      - service: slapd
{# Cert/key must be created use GNUTLS
openssl is not compatible with ubuntu ldap #}
      - file: /etc/ssl/private/ldap.pem
      - file: /etc/ssl/certs/ldap.pem
      - file: /etc/ssl/certs/ldapca.pem
      - user: openldap

/etc/ldap/bitflippers.ldif:
  file:
    - managed
    - source: salt://openldap/bitflippers.ldif
    - mode: 600

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/bitflippers.ldif:
  cmd:
    - wait
    - watch:
      - file: /etc/ldap/bitflippers.ldif
    - require:
      - service: slapd
      - cmd: slapd_config_dbs

/etc/ldap/ldap.conf:
  file:
    - managed
    - source: salt://openldap/ldap.conf
