slapd:
  pkg:
    - purged
    - pkgs:
      - slapd
      - ldap-utils
    - require:
      - service: slapd
  service:
    - dead
  file:
    - absent
    - name: /etc/ldap/ldap.conf
    - require:
      - pkg: slapd

openldap:
  user:
    - absent
    - require:
      - pkg: slapd

{{ opts['cachedir'] }}/dbconfig.ldif:
  file:
    - absent

{{ opts['cachedir'] }}/usertree.ldif:
  file:
    - absent
