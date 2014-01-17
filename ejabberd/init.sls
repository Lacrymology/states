include:
  - apt
  - nginx
  - postgresql.server

ejabberd_dependencies:
  pkg:
    - installed
    - pkgs:
      - erlang-nox
      - erlang-asn1
      - erlang-base
      - erlang-crypto
      - erlang-inets
      - erlang-mnesia
      - erlang-odbc
      - erlang-public-key
      - erlang-ssl
      - erlang-syntax-tools
    - require:
      - cmd: apt_sources

{%- set dbuserpass = salt['password.pillar']('ejabberd:db:password', 10) %}
{%- set dbuser = salt['pillar.get']('ejabberd:db:username', 'ejabberd') %}
{%- set dbname = salt['pillar.get']('ejabberd:db:name', 'ejabberd') %}

erlang_mod_pgsql:
  archive:
    - extracted
    - name: /usr/lib/erlang/lib
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/erlang_mod_pgsql.tar.gz
{%- else %}
    - source: http://archive.robotinfra.com/mirror/erlang_mod_pgsql.tar.gz
{%- endif %}
    - source_hash: md5=ef26b7ec4f06d822ab56f0da6ad467cc
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/lib/erlang/lib/pgsql
    - require:
      - pkg: ejabberd_dependencies

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
    - sources:
{%- if 'files_archive' in pillar %}
      - ejabberd: http://ftp.riken.jp/Linux/ubuntu/pool/universe/e/ejabberd/ejabberd_2.1.10-2ubuntu1.3_amd64.deb
{%- else %}
      - ejabberd: http://ftp.riken.jp/Linux/ubuntu/pool/universe/e/ejabberd/ejabberd_2.1.10-2ubuntu1.3_amd64.deb
{%- endif %}
    - require:
      - pkg: ejabberd_dependencies
  service:
    - running
    - name: ejabberd
    - enable: True
    - order: 50
    - require:
      - pkg: ejabberd
      - archive: erlang_mod_pgsql
    - watch:
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

ejabberd_psql:
  file:
    - managed
    - name: /var/lib/ejabberd/pg.sql
    - source: salt://ejabberd/database.jinja2
    - template: jinja
    - mode: 644
    - require:
      - pkg: ejabberd
  cmd:
    - wait
    - name: psql {{ dbname }} < pg.sql
    - cwd: /var/lib/ejabberd
    - user: ejabberd
    - require:
      - postgres_database: ejabberd
      - pkg: ejabberd
    - watch:
      - file: ejabberd_psql

ejabberd_reload:
  cmd:
    - wait
    - name: ejabberdctl restart; sleep 15 {# wait ejabberd service restart finish #}
    - require:
      - pkg: ejabberd
    - watch:
      - service: ejabberd
      - file: ejabberd

{%- for user in salt['pillar.get']('ejabberd:admins') %}
{%- set password = salt['pillar.get']('ejabberd:admins:' + user) %}
{%- set hostname = salt['pillar.get']('ejabberd:hostnames')[0] %}

ejabberd_reg_user_{{ user }}:
  cmd:
    - run
    - name: ejabberdctl register {{ user }} {{ hostname }} {{ password }}
    - user: root
    - unless: ejabberdctl check_account {{ user }} {{ hostname }}
    - require:
      - pkg: ejabberd
      - service: ejabberd
      - cmd: ejabberd_reload
{%- endfor %}

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
{%- if salt['pillar.get']('ejabberd:ssl', False) %}
      - cmd: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/chained_ca.crt
      - module: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/server.pem
      - file: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/ca.crt

extend:
  nginx:
    service:
      - watch:
        - cmd: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/ca.crt
{%- endif %}
