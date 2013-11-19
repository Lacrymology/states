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
{% set ssl = salt['pillar.get']('ldap:ssl', False) %}
include:
  - apt
{% if ssl %}
  - ssl
{% endif %}

slapd:
  pkg:
    - latest
    - pkgs:
      - slapd
      - ldap-utils
    - require:
      - cmd: apt_sources
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - pkg: slapd
  file:
    - managed
    - name: /etc/ldap/ldap.conf
    - source: salt://openldap/config.jinja2
    - template: jinja

{% if ssl %}
openldap:
  user:
    - present
    - groups:
      - ssl-cert
      - openldap
    - require:
      - pkg: slapd
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
      - cmd: /etc/ssl/{{ ssl }}/chained_ca.crt
      - module: /etc/ssl/{{ ssl }}/server.pem
      - file: /etc/ssl/{{ ssl }}/ca.crt
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

ldapadd -Y EXTERNAL -H ldapi:/// -f {{ opts['cachedir'] }}/usertree.ldif:
  cmd:
    - wait
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
