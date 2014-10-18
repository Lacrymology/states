{#-
Copyright (C) 2013 the Institute for Institutional Innovation by Data
Driven Design Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE  MASSACHUSETTS INSTITUTE OF
TECHNOLOGY AND THE INSTITUTE FOR INSTITUTIONAL INNOVATION BY DATA
DRIVEN DESIGN INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the names of the Institute for
Institutional Innovation by Data Driven Design Inc. shall not be used in
advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from the
Institute for Institutional Innovation by Data Driven Design Inc.

Author: Lam Dang Tung <lamdt@familug.org>
Maintainer: Lam Dang Tung <lamdt@familug.org>

Self hosted Git management software.
-#}
{%- from 'upstart/rsyslog.sls' import manage_upstart_log with context -%}
include:
  - apt
  - build
  - git
  - logrotate
  - nginx
  - nodejs
  - postgresql
  - postgresql.server
  - python
  - redis
  - ruby
  - rsyslog
  - ssh.server
{%- if salt['pillar.get']('gitlab:ssl', False) %}
  - ssl
{%- endif %}
  - uwsgi.ruby
  - web
  - xml

{%- set database_name = salt['pillar.get']('gitlab:db:name', 'gitlab') %}
{%- set database_username = salt['pillar.get']('gitlab:db:username', 'gitlab') %}
{%- set database_password = salt['password.pillar']('gitlab:db:password', 10) %}

{%- set user = 'gitlab' %}
{%- set version = '6.4.3' %}
{%- set root_dir = "/usr/local" %}
{%- set home_dir = "/home/" + user %}
{%- set web_dir = root_dir +  "/gitlabhq-" + version %}
{%- set repos_dir = home_dir + "/repositories" %}
{%- set shell_dir = home_dir + "/gitlab-shell" %}

gitlab_dependencies:
  pkg:
    - installed
    - pkgs:
      - adduser
      - libicu-dev
      - libcurl4-openssl-dev
      - libicu-dev
      - build-essential
      - python-docutils
    - require:
      - cmd: apt_sources
      - pkg: build
      - pkg: git
      - pkg: python
      - pkg: nodejs
      - pkg: postgresql-dev
      - pkg: xml-dev

gitlab_stop_old_sidekiq_process:
  cmd:
    - run
    - name: kill -9 `pgrep -u git -f 'sidekiq 2.12.4'` || true
    - onlyif: pgrep -u git -f 'sidekiq 2.12.4'

remove_old_gitlab_shell:
  file:
    - absent
    - name: {{ home_dir }}/gitlab-shell
    - require:
      - cmd: gitlab_stop_old_sidekiq_process
      - cmd: gitlab_rename_home_folder

gitlab-shell:
  archive:
    - extracted
    - name: {{ home_dir }}/
    {%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/gitlab/shell-1.8.0.tar.gz
    {%- else %}
    - source:  https://github.com/gitlabhq/gitlab-shell/archive/v1.8.0.tar.gz
    {%- endif %}
    - source_hash: md5=6f82c0917dc1a65019ec04dec4e9a7d5
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ shell_dir }}
    - require:
      - user: gitlab
      - file: remove_old_gitlab_shell
  file:
    - directory
    - name: {{ home_dir }}
    - user: {{ user }}
    - group: {{ user }}
    - recurse:
      - user
      - group
    - require:
      - cmd: gitlab-shell
  cmd:
    - run
    - name: mv gitlab-shell-1.8.0 gitlab-shell
    - cwd: {{ home_dir }}
    - onlyif: test -d {{ home_dir }}/gitlab-shell-1.8.0
    - require:
      - archive: gitlab-shell

install_gitlab_shell:
  cmd:
    - run
    - name: {{ shell_dir }}/bin/install
    - user: {{ user }}
    - require:
      - pkg: ruby
      - cmd: gitlab-shell
    - watch:
      - file: {{ shell_dir }}/config.yml
      - archive: gitlab-shell

gitlab_shell_logfile:
  file:
    - managed
    - name: {{ shell_dir }}/gitlab-shell.log
    - mode: 660
    - user: {{ user }}
    - group: {{ user }}
    - require:
      - file: gitlab-shell

{{ shell_dir }}/config.yml:
  file:
    - managed
    - source: salt://gitlab/gitlab-shell.jinja2
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 440
    - require:
      - file: gitlab-shell
      - pkg: ruby
    - context:
      repos_dir: {{ repos_dir }}
      shell_dir: {{ shell_dir }}
      user: {{ user }}

{#- move old data in to new home folder #}
gitlab_rename_home_folder:
  cmd:
    - run
    - name: mv /home/git {{ home_dir }}
    - user: root
    - onlyif: test -d /home/git

replace_git_home_in_file:
  cmd:
    - wait
    - name:  find {{ home_dir }} -type f -exec sed -i 's:/home/git/:/home/gitlab/:g' {} \;
    - user: root
    - watch:
      - cmd: gitlab_rename_home_folder

gitlab_remove_old_version:
  file:
    - absent
    - name: /usr/local/gitlabhq-6-0-stable

{{ web_dir }}:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - recurse:
      - user
      - group
    - require:
      - archive: gitlab

gitlab:
  user:
    - present
    - name: {{ user }}
    - home: {{ home_dir }}
    - groups:
      - www-data
    - shell: /bin/bash
    - require:
      - pkg: gitlab_dependencies
      - group: web
      - cmd: gitlab_rename_home_folder
      - cmd: replace_git_home_in_file
  postgres_user:
    - present
    - name: {{ database_username }}
    - password: {{ database_password }}
    - require:
      - service: postgresql
      - cmd: install_gitlab_shell
  postgres_database:
    - present
    - name: {{ database_name }}
    - owner: {{ database_username }}
    - require:
      - postgres_user: gitlab
  archive:
    - extracted
    - name: {{ root_dir }}/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/gitlab/{{ version }}.tar.gz
{%- else %}
    - source: https://github.com/gitlabhq/gitlabhq/archive/v{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=a66d5504b154aacc68aefae9445f3fd2
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_dir }}
    - require:
      - postgres_database: gitlab
      - file: /usr/local
      - file: gitlab_remove_old_version
  file:
    - managed
    - name: /etc/init/gitlab.conf
    - user: root
    - mode: 440
    - source: salt://gitlab/upstart.jinja2
    - template: jinja
    - require:
      - cmd: gitlab
    - context:
      web_dir: {{ web_dir }}
      user: {{ user }}
  cmd:
    - wait
    - name: force=yes bundle exec rake gitlab:setup
    - env:
        RAILS_ENV: production
    - user: {{ user }}
    - cwd: {{ web_dir }}
    - require:
      - service: redis
      - cmd: bundler
      - file: {{ web_dir }}/db/fixtures/production/001_admin.rb
    - watch:
      - postgres_database: gitlab
  service:
    - running
    - name: gitlab
    - require:
      - user: gitlab
    - watch:
      - archive: gitlab
      - cmd: gitlab
      - cmd: bundler
      - cmd: gitlab_precompile_assets
      - file: gitlab
      - file: {{ web_dir }}/config.ru
      - file: {{ web_dir }}/config/gitlab.yml
      - file: {{ web_dir }}/config/initializers/rack_attack.rb
{%- if salt['pillar.get']('gitlab:smtp:enabled', False) %}
      - file: {{ web_dir }}/config/environments/production.rb
      - file: {{ web_dir }}/config/initializers/smtp_settings.rb
{%- endif %}

{{ manage_upstart_log('gitlab') }}

gitlab-uwsgi:
  file:
    - managed
    - name: /etc/uwsgi/gitlab.yml
    - source: salt://gitlab/uwsgi.jinja2
    - group: www-data
    - user: www-data
    - template: jinja
    - mode: 440
    - context:
      appname: gitlab
      chdir: {{ web_dir }}
      rack: {{ web_dir }}/config.ru
    - require:
      - cmd: gitlab
      - cmd: gitlab_precompile_assets
      - service: uwsgi
      - file: gitlab
      - gem: rack
      - file: {{ web_dir }}/config.ru
      - postgres_database: gitlab
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/gitlab.yml
    - require:
      - file: /etc/uwsgi/gitlab.yml
    - watch:
      - user: gitlab
      - file: {{ web_dir }}/config/gitlab.yml
      - file: {{ web_dir }}/config/database.yml
{%- if salt['pillar.get']('gitlab:smtp:enabled', False) %}
      - file: {{ web_dir }}/config/environments/production.rb
      - file: {{ web_dir }}/config/initializers/smtp_settings.rb
{%- endif %}
      - archive: gitlab

gitlab_migrate_db:
  cmd:
    - run
    - name: bundle exec rake db:migrate
    - env:
        RAILS_ENV: production
    - user: {{ user }}
    - cwd: {{ web_dir }}
    - require:
      - cmd: gitlab
      - archive: gitlab
      - service: redis
      - cmd: bundler
      - file: {{ web_dir }}/db/fixtures/production/001_admin.rb

gitlab_coppy_images:
  cmd:
    - run
    - name: cp {{ web_dir }}/app/assets/images/* {{ web_dir }}/public/assets/
    - user: {{ user }}
    - unless: test -f {{ web_dir }}/public/assets/logo-black.png
    - require:
      - archive: gitlab
      - user: gitlab
      - cmd: gitlab_precompile_assets

gitlab_precompile_assets:
  cmd:
    - wait
    - name: bundle exec rake assets:precompile
    - env:
        RAILS_ENV: production
    - user: {{ user }}
    - cwd: {{ web_dir }}
    - unless: test -d {{ web_dir }}/public/assets/
    - watch:
      - cmd: gitlab_migrate_db
      - cmd: gitlab
      - cmd: bundler

{%- if version == '6.4.3' %}
gitlab_migrate_miids:
  cmd:
    - run
    - name: bundle exec rake migrate_iids RAILS_ENV=production
    - env:
        RAILS_ENV: production
    - user: {{ user }}
    - cwd: {{ web_dir }}
    - require:
      - cmd: gitlab_migrate_db
      - archive: gitlab
{%- endif %}

gitlab_update_hook:
  cmd:
    - script
    - name: rewrite-hooks.sh {{ repos_dir }}
    - source: salt://gitlab/rewrite-hooks.sh
    - template: jinja
    - shell: /bin/bash
    - user: {{ user }}
    - cwd: {{ shell_dir }}/support
    - require:
      - file: gitlab-shell
    - watch:
      - archive: gitlab
    - context:
      user: {{ user }}

gitlab_clean_redis_db:
  cmd:
    - wait
    - name: redis-cli flushdb
    - require:
      - service: redis
    - watch:
      - cmd: gitlab
      - archive: gitlab

{{ web_dir }}/config.ru:
  file:
    - managed
    - source: salt://gitlab/config.jinja2
    - user: {{ user }}
    - group: {{ user }}
    - template: jinja
    - mode: 440
    - require:
      - cmd: gitlab

{{ home_dir }}/gitlab-satellites:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - mode: 775
    - require:
      - user: {{ user }}

{%- for dir in ('log', 'tmp', 'public/uploads', 'tmp/pids', 'tmp/cache') %}
{{ web_dir }}/{{ dir }}:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - dir_mode: 775
    - file_mode: 664
    - recurse:
      - user
      - group
      - mode
    - require:
      - file: gitlab
    - require_in:
      - file: {{ home_dir }}/gitlab-satellites
{%- endfor %}

{%- for file in ('gitlab.yml', 'database.yml') %}
{{ web_dir }}/config/{{ file }}:
  file:
    - managed
    - source: salt://gitlab/{{ file }}.jinja2
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 440
    - require:
      - file: gitlab
    - require_in:
      - file: {{ home_dir }}/gitlab-satellites
    - context:
      home_dir: {{ home_dir }}
      repos_dir: {{ repos_dir }}
      shell_dir: {{ shell_dir }}
      user: {{ user }}
{%- endfor %}

{{ web_dir }}/config/initializers/rack_attack.rb:
  file:
    - managed
    - source: salt://gitlab/rack_attack.rb.jinja2
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 440
    - require:
      - file: gitlab
    - require_in:
      - file: {{ home_dir }}/gitlab-satellites

/etc/logrotate.d/gitlab:
  file:
    - managed
    - source: salt://gitlab/logrotate.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: logrotate
      - file: gitlab
    - context:
      web_dir: {{ web_dir }}
      user: {{ user }}

charlock_holmes:
  gem:
    - installed
    - version: 0.6.9.4
    - runas: root
    - require:
      - file: gitlab
      - file: {{ home_dir }}/gitlab-satellites
      - pkg: gitlab_dependencies

bundler:
  gem:
    - installed
    - version: 1.3.5
    - runas: root
    - require:
      - gem: charlock_holmes
  cmd:
    - run
    - name: bundle install --deployment --without development test mysql aws
    - cwd: {{ web_dir }}
    - user: {{ user }}
    - require:
      - gem: bundler

{%- set rack_version = '1.5.2' %}

{#- Can not use gem.removed function here, because it does not support uninstall
without confirmation option #}
gitlab_rack_gem:
  cmd:
    - run
    - name: gem uninstall -Iax rack --version '<{{ rack_version }}'
    - onlyif: gem list | grep rack
    - require:
      - pkg: ruby
  gem:
    - installed
    - name: rack
    - version: {{ rack_version }}
    - runas: root
    - require:
      - pkg: ruby
      - pkg: build
      - cmd: gitlab_rack_gem

/etc/nginx/conf.d/gitlab.conf:
  file:
    - managed
    - source: salt://gitlab/nginx.jinja2
    - template: jinja
    - group: www-data
    - user: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - user: web
      - file: gitlab-uwsgi
{%- if salt['pillar.get']('gitlab:ssl', False) %}
      - cmd: ssl_cert_and_key_for_{{ pillar['gitlab']['ssl'] }}
{%- endif %}
    - watch_in:
      - service: nginx
    - context:
      web_dir: {{ web_dir }}

{{ home_dir }}/.gitconfig:
  file:
    - managed
    - source: salt://gitlab/gitconfig.jinja2
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 640
    - require:
      - user: {{ user }}

{%- if salt['pillar.get']('gitlab:smtp:enabled', False) %}
{{ web_dir }}/config/environments/production.rb:
  file:
    - managed
    - source: salt://gitlab/production.jinja2
    - user: {{ user }}
    - group: {{ user }}
    - template: jinja
    - mode: 440
    - require:
      - user: gitlab
      - file: gitlab
    - require_in:
      - cmd: bundler

{{ web_dir }}/config/initializers/smtp_settings.rb:
  file:
    - managed
    - source: salt://gitlab/smtp.jinja2
    - user: {{ user }}
    - group: {{ user }}
    - template: jinja
    - mode: 440
    - require:
      - user: gitlab
      - file: gitlab
    - require_in:
      - cmd: bundler
{%- endif %}

{{ web_dir }}/db/fixtures/production/001_admin.rb:
  file:
    - managed
    - source: salt://gitlab/admin.jinja2
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 640
    - require:
      - file: gitlab
    - require_in:
      - file: {{ home_dir }}/gitlab-satellites

{%- for file in ('Gemfile', 'Gemfile.lock') %}
{{ web_dir }}/{{ file }}:
  file:
    - managed
    - source: salt://gitlab/{{ file }}
    - user: {{ user }}
    - group: {{ user }}
    - mode: 440
    - require:
      - user: gitlab
      - file: {{ web_dir }}
    - require_in:
      - cmd: bundler
{%- endfor %}

extend:
  web:
    user:
      - groups:
        - gitlab
      - require:
        - user: gitlab
      - watch_in:
        - file: gitlab-uwsgi
{%- if salt['pillar.get']('gitlab:ssl', False) %}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ pillar['gitlab']['ssl'] }}
{%- endif %}
