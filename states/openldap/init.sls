slapd:
  pkg:
    - installed
  service:
    - running
    - enable: False

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
    - unless: 'grep olcLogLevel /etc/ldap/slapd.d/cn=config.ldif'
    - require:
      - file: /tmp/logging.ldif

{% for i in ('cacert.pem', 'servercrt.pem', 'serverkey.pem') %}
/etc/ldap/tls/{{ i }}:
  file:
    - managed
    - source: salt://openldap/{{ i }}
    - uid: openldap
    - gid: openldap
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
      - file: /tmp/tls.ldif
{% for i in ('cacert.pem', 'servercrt.pem', 'serverkey.pem') %}
      - file: /etc/ldap/tls/{{ i }}
{% endfor %}
