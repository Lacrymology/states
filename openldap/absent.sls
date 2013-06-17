slapd:
  pkg:
    - purged
    - pkgs:
      - slapd
    - require:
      - service: slapd
  service:
    - dead
  file:
    - absent
    - name: /etc/ldap/ldap.conf
    - require:
      - pkg: slapd

{# as long as https://github.com/saltstack/salt/issues/5572 isn't fixed
   the following is required: #}
ldap-utils:
  pkg:
    - purged
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
