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
    - wait
    - name: 'ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/logging.ldif'
    - watch:
      - pkg: slapd
    - require:
      - file: /tmp/logging.ldif


