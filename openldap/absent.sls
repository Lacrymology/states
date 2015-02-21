{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
    - name: /etc/ldap
    - require:
      - pkg: slapd

/var/lib/ldap:
  file:
    - absent
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
