{#-
Copyright (c) 2013, Hung Nguyen Viet
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Hung Nguyen Viet <hvnsweeting@gmail.com>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>

A LDAP server.
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
{% set suffix = pillar['ldap']['suffix'] %}
{%- for domain in pillar['ldap']['data'] %}
  {%- for uid in pillar['ldap']['data'][domain] %}
    {% set u = pillar['ldap']['data'][domain][uid] %}
{{ ldap_adduser(uid, domain, suffix, u['cn'], u['sn'], u['passwd']) }}
  {%- endfor %}
{%- endfor %}

{%- for domain in salt['pillar.get']('ldap:absent', []) %}
  {%- for uid in pillar['ldap']['absent'][domain] %}
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
