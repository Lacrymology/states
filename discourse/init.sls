{#-
Copyright (c) 2013, Lam Dang Tung

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Author: Lam Dang Tung <lamdt@familug.org>
Maintainer: Lam Dang Tung <lamdt@familug.org>

Install Discourse - Discussion Platform.
#}

include:
  - apt
  - build
  - git
  - logrotate
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

{%- set version = "0.9.6.3" %}
{%- set web_root_dir = "/usr/local/discourse-" + version %}
{%- set password = salt['password.pillar']('discourse:database:password', 10) %}
{%- set username = salt['pillar.get']('discourse:database:username', 'discourse') %}
{%- set dbname = salt['pillar.get']('discourse:database:name', 'discourse') %}

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
      - pkg: git

discourse_tar:
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/discourse/v{{ version }}.tar.gz
{%- else %}
    - source: http://archive.robotinfra.com/mirror/discourse/v{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=7e608572bfa2902aaa53cb229cf56516
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
    - name: {{ username }}
    - password: {{ password }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ dbname }}
    - owner: {{ username }}
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
      - service: redis
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
      dbname: {{ dbname }}
      username: {{ username }}

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

discourse_upstart:
  service:
    - running
    - name: discourse
    - watch:
      - file: discourse_upstart
  file:
    - managed
    - name: /etc/init/discourse.conf
    - source: salt://discourse/upstart.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/uwsgi/discourse.ini
    - context:
      web_root_dir: {{ web_root_dir }}
      user: discourse
      home: /home/discourse

/etc/logrotate.d/discourse:
  file:
    - managed
    - source: salt://discourse/logrotate.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: logrotate
      - file: discourse_upstart
    - context:
      web_root_dir: {{ web_root_dir }}

/etc/uwsgi/discourse.ini:
  file:
    - managed
    - user: www-data
    - group: www-data
    - template: jinja
    - source: salt://discourse/uwsgi.jinja2
    - mode: 440
    - require:
      - service: uwsgi_emperor
      - file: discourse_tar
      - file: discourse
      - file: {{ web_root_dir }}/config/environments/production.rb
      - file: {{ web_root_dir }}/config/database.yml
      - file: {{ web_root_dir }}/config/redis.yml
      - user: add_web_user_to_discourse_group
      - cmd: discourse_bundler
      - cmd: discourse
      - gem: discourse_rack
      - postgres_database: discourse
      - cmd: discourse_assets_precompile
    - context:
      web_root_dir: {{ web_root_dir }}
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/discourse.ini
    - require:
      - file: /etc/uwsgi/discourse.ini
    - watch:
      - file: discourse
      - file: {{ web_root_dir }}/config/environments/production.rb
      - file: {{ web_root_dir }}/config/database.yml
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
      - cmd: /etc/ssl/{{ pillar['discourse']['ssl'] }}/chained_ca.crt
      - module: /etc/ssl/{{ pillar['discourse']['ssl'] }}/server.pem
      - file: /etc/ssl/{{ pillar['discourse']['ssl'] }}/ca.crt
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

{%- if salt['pillar.get']('discourse:ssl', False) %}
extend:
  nginx:
    service:
      - watch:
        - cmd: /etc/ssl/{{ pillar['discourse']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['discourse']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['discourse']['ssl'] }}/ca.crt
{%- endif %}
