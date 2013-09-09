{#-
Install Discourse - Discussion Platform
=================

Mandatory Pillar
----------------
discourse:
  hostnames:
    - list of hostname, used for nginx config

Optional Pillar
---------------
discourse:
  smtp: False
  ssl: False

#}

include:
  - apt
  - build
  - nginx
  - postgresql
  - postgresql.server
  - redis
  - ruby
{%- if salt['pillar.get']('discourse:ssl', False) %}
  - ssl
{%- endif %}
  - xml
  - uwsgi.ruby
  - web

{%- set web_root_dir = "/usr/local/discourse-master" %}
{%- set password = salt['password.pillar']('discourse:database:password', 10) %}

discourse_deps:
  pkg:
    - installed
    - pkgs:
      - libssl-dev
      - build-essential
      - libtool
      - gawk
      - curl
      - pngcrush
      - imagemagick
      - postgresql-contrib-9.2
    - require:
      - pkg: xml-dev
      - pkg: postgresql-dev
      - pkg: ruby

discourse_tar:
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
    - source: https://github.com/discourse/discourse/archive/master.tar.gz
    - source_hash: md5=8061aa8f716e9e264d47a1600174488a
{%- else %}
    - source: https://github.com/discourse/discourse/archive/master.tar.gz
    - source_hash: md5=5ea1b394f08131267d92c6bb8f5693e5
{%- endif %}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_root_dir }}
    - require:
      - file: /usr/local
  file:
    - directory
    - name: {{ web_root_dir }}
    - user: discourse
    - group: discourse
    - recurse:
      - user
      - group
    - require:
      - user: discourse
      - archive: discourse_tar

{%- set ruby_version = "1.9.3" %}
discourse:
  user:
    - present
    - name: discourse
    - shell: /bin/bash
    - groups:
      - www-data
    - require:
      - pkg: discourse_deps
      - user: web
  postgres_user:
    - present
    - name: discourse
    - password: {{ password }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: discourse
    - owner: discourse
    - runas: postgres
    - require:
      - postgres_user: discourse
  cmd:
    - wait
    - name: rake{{ ruby_version }} db:migrate
    - cwd: {{ web_root_dir }}
    - user: discourse
    - env:
        RAILS_ENV: production
        RUBY_GC_MALLOC_LIMIT: "90000000"
    - require:
      - file: discourse_tar
      - file: {{ web_root_dir }}/config/database.yml
      - user: discourse
      - service: postgresql
      - postgres_database: discourse
    - watch:
      - cmd: discourse_add_psql_extension_hstore
      - cmd: discourse_add_psql_extension_pg_trgm
  file:
    - managed
    - name: {{ web_root_dir }}/config.ru
    - user: discourse
    - group: discourse
    - mode: 440
    - source: salt://discourse/config.jinja2
    - template: jinja
    - require:
      - file: discourse_tar
      - user: discourse

discourse_rack:
  gem:
    - installed
    - name: rack
    - version: 1.4.5
    - runas: root
    - require:
      - pkg: ruby
      - pkg: build


{{ web_root_dir }}/config/database.yml:
  file:
    - managed
    - source: salt://discourse/database.jinja2
    - template: jinja
    - user: discourse
    - group: discourse
    - mode: 440
    - require:
      - user: discourse
      - file: discourse_tar
    - context:
      password: {{ password }}

{{ web_root_dir }}/config/environments/production.rb:
  file:
    - managed
    - user: discourse
    - group: discourse
    - mode: 440
    - template: jinja
    - source: salt://discourse/production.jinja2
    - require:
      - user: discourse
      - file: discourse_tar

{{ web_root_dir }}/config/redis.yml:
  file:
    - managed
    - source: salt://discourse/redis.jinja2
    - template: jinja
    - user: discourse
    - group: discourse
    - mode: 440
    - require:
      - user: discourse
      - file: discourse_tar

discourse_bundler:
  gem:
    - installed
    - name: bundler
    - require:
      - pkg: ruby
      - pkg: build
  cmd:
    - run
    - name: bundle install --deployment --without test
    - user: discourse
    - cwd: {{ web_root_dir }}
    - require:
      - gem: discourse_bundler
      - file: discourse_tar
      - user: discourse

/etc/uwsgi/discourse.ini:
  file:
    - managed
    - user: www-data
    - group: www-data
    - template: jinja
    - source: salt://discourse/uwsgi.jinja2
    - mode: 440
    - require:
      - file: uwsgi_sockets
      - file: discourse_tar
      - file: discourse
      - file: {{ web_root_dir }}/config/environments/production.rb
      - file: {{ web_root_dir }}/config/database.yml
      - file: {{ web_root_dir }}/config/redis.yml
      - user: add_web_user_to_discourse_group
      - cmd: discourse_bundler
      - cmd: discourse
      - gem: discourse_rack
    - watch_in:
      - service: uwsgi_emperor
    - context:
      web_root_dir: {{ web_root_dir }}
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/discourse.ini
    - watch:
      - file: discourse
      - file: {{ web_root_dir }}/config/database.yml
      - file: {{ web_root_dir }}/config/environments/production.rb
      - file: {{ web_root_dir }}/config/redis.yml
      - file: discourse_tar

/etc/nginx/conf.d/discourse.conf:
  file:
    - managed
    - user: www-data
    - group: www-data
    - template: jinja
    - source: salt://discourse/nginx.jinja2
    - mode: 440
    - require:
      - pkg: nginx
      - file: /etc/uwsgi/discourse.ini
{%- if salt['pillar.get']('discourse:ssl', False) %}
      - cmd: /etc/ssl/{{ salt['pillar.get']('discourse:ssl') }}/chained_ca.crt
      - module: /etc/ssl/{{ salt['pillar.get']('discourse:ssl') }}/server.pem
      - file: /etc/ssl/{{ salt['pillar.get']('discourse:ssl') }}/ca.crt
{%- endif %}
    - watch_in:
      - service: nginx
    - context:
      web_root_dir: {{ web_root_dir }}

add_web_user_to_discourse_group:
  user:
    - present
    - name: www-data
    - groups:
      - discourse
    - require:
      - user: web
      - user: discourse

discourse_add_psql_extension_hstore:
  cmd:
    - run
    - name: psql discourse -c "CREATE EXTENSION IF NOT EXISTS hstore;"
    - user: postgres
    - require:
      - service: postgresql
      - postgres_database: discourse

discourse_add_psql_extension_pg_trgm:
  cmd:
    - run
    - name: psql discourse -c "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
    - user: postgres
    - require: 
      - service: postgresql
      - postgres_database: discourse
      {#-
discourse_assets_precompile:
  cmd:
    - wait
    - name: rake{{ ruby_version }} assets:precompile
    - cwd: {{ web_root_dir }}
    - user: discourse
    - env:
        RAILS_ENV: production
        RUBY_GC_MALLOC_LIMIT: "90000000"
    - require:
      - user: discourse
      - file: discourse_tar
    - watch:
      - cmd: discourse
      #}
{%- if salt['pillar.get']('discourse:ssl', False) %}
extend:
  nginx:
    service:
      - watch:
        - cmd: /etc/ssl/{{ salt['pillar.get']('discourse:ssl') }}/chained_ca.crt
        - module: /etc/ssl/{{ salt['pillar.get']('discourse:ssl') }}/server.pem
        - file: /etc/ssl/{{ salt['pillar.get']('discourse:ssl') }}/ca.crt
{%- endif %}
