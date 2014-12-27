{#-
Copyright (c) 2014, Dang Tung Lam
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

Author: Dang Tung Lam <lam@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- set ssl = salt['pillar.get']('ejabberd:ssl', False) %}

include:
  - apt
  - erlang
  - erlang.pgsql
  - locale
  - nginx
  - postgresql.server
{%- if ssl %}
  - ssl
{%- endif %}

{%- set dbuserpass = salt['password.pillar']('ejabberd:db:password', 10) %}
{%- set dbuser = salt['pillar.get']('ejabberd:db:username', 'ejabberd') %}
{%- set dbname = salt['pillar.get']('ejabberd:db:name', 'ejabberd') %}

ejabberd:
  postgres_user:
    - present
    - name: {{ dbuser }}
    - password: {{ dbuserpass }}
    - runas: postgres
    - require:
      - service: postgresql
      - pkg: ejabberd
  postgres_database:
    - present
    - name: {{ dbname }}
    - owner: {{ dbuser }}
    - runas: postgres
    - require:
      - postgres_user: ejabberd
  pkg:
    - installed
    - require:
      - host: hostname
      - cmd: hostname
      - pkg: postgresql
      - cmd: erlang_mod_pgsql
      - cmd: system_locale
  service:
    - running
    - name: ejabberd
    - enable: True
    - order: 50
    - sig: ejabberd
    - require:
      - pkg: ejabberd
      - cmd: erlang_mod_pgsql
      - cmd: hostname
      - file: ejabberd_init
    - watch:
    {%- if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
    {%- endif %}
      - user: ejabberd
      - file: ejabberd
      - cmd: ejabberd_psql
  file:
    - managed
    - name: /etc/ejabberd/ejabberd.cfg
    - source: salt://ejabberd/config.jinja2
    - template: jinja
    - user: ejabberd
    - group: ejabberd
    - mode: 600
    - require:
      - pkg: ejabberd
      - postgres_database: ejabberd
      - cmd: ejabberd_psql
    - context:
        dbname: {{ dbname }}
        dbuser: {{ dbuser }}
        dbuserpass: {{ dbuserpass }}
  user:
    - present
    - shell: /usr/sbin/nologin
  {%- if ssl %}
    - groups:
      - ssl-cert
  {%- endif %}
    - require:
      - pkg: ejabberd

ejabberd_init:
  file:
    - replace
    - name: /etc/init.d/ejabberd
    - pattern: 'EJABBERDUSER -c'
    - repl: 'EJABBERDUSER -s /bin/sh -c'
    - backup: False
    - require:
      - pkg: ejabberd

ejabberd_psql:
  file:
    - managed
    - name: /var/lib/ejabberd/pg.sql
    - source: salt://ejabberd/database.jinja2
    - template: jinja
    - user: ejabberd
    - group: ejabberd
    - mode: 644
    - require:
      - pkg: ejabberd
  cmd:
    - wait
    - name: psql {{ dbname }} < pg.sql
    - cwd: /var/lib/ejabberd
    - user: ejabberd
    - require:
      - pkg: ejabberd
    - watch:
      - file: ejabberd_psql
      - postgres_database: ejabberd

{%- set monitor_user = "ejabberd_monitor" %}
{%- set hostname = salt['pillar.get']('ejabberd:hostnames')[0] %}
{%- set monitor_password = salt['password.generate']('ejabberd_monitor') %}

{%- for user in salt['pillar.get']('ejabberd:admins') %}
  {%- set password = salt['pillar.get']('ejabberd:admins')[user] %}
ejabberd_reg_{{ user }}:
  cmd:
    - wait
    - name: ejabberdctl register '{{ user }}' '{{ hostname }}' '{{ password }}'
    - user: root
    - unless: ejabberdctl check-account '{{ user }}' '{{ hostname }}'
    - require:
      - pkg: ejabberd
      - service: ejabberd
    - watch:
      - postgres_database: ejabberd
{%- endfor %}

ejabberd_reg_monitor_user:
  cmd:
    - run
    - name: ejabberdctl register {{ monitor_user }} {{ hostname }} {{ monitor_password }}
    - user: root
    - unless: ejabberdctl check-account {{ monitor_user }} {{ hostname }}
    - require:
      - pkg: ejabberd
      - service: ejabberd

/etc/nginx/conf.d/ejabberd.conf:
  file:
    - managed
    - template: jinja
    - source: salt://ejabberd/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - watch_in:
      - service: nginx
    - require:
      - pkg: nginx
      - service: ejabberd

{%- if ssl %}
extend:
  nginx.conf:
    file:
      - context:
          ssl: {{ ssl }}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{%- endif %}
