{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'macros.jinja2' import manage_pid with context %}
{% set ssl = salt['pillar.get']('ldap:ssl', False) %}
include:
  - apt
  - hostname
{% if ssl %}
  - ssl
{% endif %}

{%- call manage_pid('/var/run/slapd/slapd.pid', 'openldap', 'openldap', 'slapd') %}
- pkg: slapd
- user: openldap
{%- endcall %}

slapd:
  pkg:
    - latest
    - pkgs:
      - slapd
      - ldap-utils
    - require:
      - cmd: apt_sources
      - host: hostname
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - pkg: slapd
      - user: openldap
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
  file:
    - managed
    - name: /etc/ldap/ldap.conf
    - source: salt://openldap/config.jinja2
    - mode: 444
    - template: jinja

openldap:
  user:
    - present
    - shell: /bin/false
    - groups:
{% if ssl %}
      - ssl-cert
{% endif %}
      - openldap
    - require:
      - pkg: slapd
{% if ssl %}
      - pkg: ssl-cert
{% endif %}

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
      - cmd: ssl_cert_and_key_for_{{ ssl }}
      - user: openldap

restart_after_ssl:
  cmd:
    - wait
    - name: service slapd restart
    - watch:
      - cmd: slapd_config_dbs
{% endif %}

{{ opts['cachedir'] }}/usertree.ldif:
  file:
    - managed
    - template: jinja
    - source: salt://openldap/usertree.ldif.jinja2
    - mode: 400

ldap_create_user_tree:
  cmd:
    - wait
    - name: ldapadd -Y EXTERNAL -H ldapi:/// -f {{ opts['cachedir'] }}/usertree.ldif
    - watch:
      - pkg: slapd
      {#- only run the first time when install slapd, ldapadd against  a file
      cannot run multiple times, it will fail as soon as one entry exists.
      This can be solved by ldap state module - but it's not available now.
      #}
    - require:
      - file: {{ opts['cachedir'] }}/usertree.ldif
      - service: slapd
      - cmd: slapd_config_dbs

{%- macro ldap_adduser(uid, domain, suffix, cn, sn, password) %}
ldap_{{ domain }}_{{ uid }}:
  cmd:
    - run
    - unless:  ldapsearch -H ldapi:/// -Y EXTERNAL -b'uid={{ uid }}@{{ domain }},ou=people,{{ suffix }}' -LLL -A
    - name: |
        ldapadd -H ldapi:/// -Y EXTERNAL << __EOF
        dn: uid={{ uid }}@{{ domain }},ou=people,{{ suffix }}
        objectClass: inetOrgPerson
        cn: {{ cn }}
        sn: {{ sn }}
        uid: {{ uid }}@{{ domain }}
        userPassword: {{ password }}
        __EOF
    - require:
      - cmd: ldap_create_user_tree
    - require_in:
      - file: openldap_formula_interface
{%- endmacro %}

{#- create / delete user entries #}
{% set suffix = salt['pillar.get']('ldap:suffix') %}
{%- set ldapdata = salt['pillar.get']('ldap:data', {}) %}
{%- for domain in ldapdata %}
  {%- for uid in ldapdata[domain] %}
    {% set u = ldapdata[domain][uid] %}
{{ ldap_adduser(uid, domain, suffix, u['cn'], u['sn'], u['passwd']) }}
  {%- endfor %}
{%- endfor %}

{%- set absent_data = salt['pillar.get']('ldap:absent', {}) %}
{%- for domain in absent_data %}
  {%- for uid in absent_data[domain] %}
ldap_{{ domain }}_{{ uid }}: # make it will conflict if one DN in both ``data`` and ``absent``
  cmd:
    - run
    - onlyif: ldapsearch -H ldapi:/// -Y EXTERNAL -b'uid={{ uid }}@{{ domain }},ou=people,{{ suffix }}' -LLL -A
    - name: ldapdelete -H ldapi:/// -Y EXTERNAL "uid={{ uid }}@{{ domain }},ou=people,{{ suffix }}"
    - require:
      - cmd: ldap_create_user_tree
    - require_in:
      - file: openldap_formula_interface
  {%- endfor %}
{%- endfor %}

{#- dummy state which should be the last state will be run in this SLS #}
openldap_formula_interface:
  file:
    - name: /etc/ldap
    - directory
    - require:
      - pkg: slapd
