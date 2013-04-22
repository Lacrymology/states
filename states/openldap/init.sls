slapd:
  pkg:
    - installed
  service:
    - running
    - enable: False
    - require: 
      - pkg: slapd

ldap-utils:
  pkg:
    - installed

/tmp/logging.ldif:
  file:
    - managed
    - source: salt://openldap/logging.ldif

slapd_change_log_level:
  cmd:
    - run
    - name: 'ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/logging.ldif'
    - unless: 'grep "olcLogLevel: 16383" /etc/ldap/slapd.d/cn=config.ldif'
    - require:
      - file: /tmp/logging.ldif
      - service: slapd

{% for i in ('cacert.pem', 'servercrt.pem', 'serverkey.pem') %}
/etc/ldap/tls/{{ i }}:
  file:
    - managed
    - source: salt://openldap/{{ i }}
    - user: openldap
    - group: openldap
    - makedirs: true
    - require:
      - pkg: slapd
{% endfor %}

/tmp/tls.ldif:
  file:
    - managed
    - source: salt://openldap/tls.ldif

slapd_set_tls_directives:
  cmd:
    - run
    - name: 'ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/tls.ldif'
    - require:
      - pkg: ldap-utils
      - service: slapd
      - file: /tmp/tls.ldif

{# Cert/key must be created use GNUTLS
openssl is not compatible with ubuntu ldap #}
{% for i in ('cacert.pem', 'servercrt.pem', 'serverkey.pem') %}
      - file: /etc/ldap/tls/{{ i }}
{% endfor %}

/etc/ldap/ldap.conf:
  file:
    - managed
    - source: salt://openldap/ldap.conf
