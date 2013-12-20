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
{%- set version = '6-0' %}
{%- set root_dir = "/usr/local" %}
{%- set home_dir = "/home/" + user %}
{%- set web_dir = root_dir +  "/gitlabhq-" + version + "-stable"  %}
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
    - require:
      - cmd: apt_sources
      - pkg: build
      - pkg: git
      - pkg: python
      - pkg: nodejs
      - pkg: postgresql-dev
      - pkg: xml-dev

gitlab-shell:
  archive:
    - extracted
    - name: {{ home_dir }}/
    {%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/gitlab/shell-fbaf8d8c12dcb9d820d250b9f9589318dbc36616.tar.gz
    {%- else %}
    - source:  http://archive.robotinfra.com/mirror/gitlab/shell-fbaf8d8c12dcb9d820d250b9f9589318dbc36616.tar.gz
    {%- endif %}
    - source_hash: md5=fa679c88f382211b34ecd35bfbb54ea6
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ shell_dir }}
    - require:
      - user: gitlab
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
    - name: mv gitlab-shell-master gitlab-shell
    - cwd: {{ home_dir }}
    - user: {{ user }}
    - onlyif: ls {{ home_dir }} | grep gitlab-shell-master
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
move_git_home:
  cmd:
    - run
    - name: mv /home/git {{ home_dir }}
    - cwd: /home
    - user: root
    - onlyif: ls /home/git

change_git_command:
  cmd:
    - run
    - name:  sed -i s@/home/git/@/home/{{ user }}/@g {{ home_dir }}/.ssh/authorized_keys
    - user: root
    - onlyif: ls {{ home_dir }}/.ssh/authorized_keys
    - require:
      - cmd: move_git_home

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
      - cmd: move_git_home
      - cmd: change_git_command
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
    - source: {{ pillar['files_archive'] }}/mirror/gitlab/{{ version|replace("-", ".") }}.tar.gz
{%- else %}
    - source: http://archive.robotinfra.com/mirror/gitlab/{{ version|replace("-", ".") }}.tar.gz
{%- endif %}
    - source_hash: md5=151be72dc60179254c58120098f2a84e
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_dir }}
    - require:
      - postgres_database: gitlab
      - file: /usr/local
  file:
    - directory
    - name: {{ web_dir }}
    - user: {{ user }}
    - group: {{ user }}
    - recurse:
      - user
      - group
    - require:
      - archive: gitlab
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
  uwsgi:
    - available
    - enabled: True
    - name: gitlab
    - source: salt://gitlab/uwsgi.jinja2
    - group: www-data
    - user: www-data
    - template: jinja
    - mode: 440
    - context:
      web_dir: {{ web_dir }}
    - require:
      - cmd: gitlab
      - cmd: gitlab_start_sidekiq_service
      - cmd: gitlab_precompile_assets
      - service: uwsgi_emperor
      - file: gitlab_upstart
      - gem: rack
      - file: {{ web_dir }}/config.ru
      - postgres_database: gitlab
    - watch:
      - user: gitlab
      - file: {{ web_dir }}/config/gitlab.yml
      - file: {{ web_dir }}/config/database.yml
 {%- if salt['pillar.get']('gitlab:smtp:enabled', False) %}
      - file: {{ web_dir }}/config/environments/production.rb
      - file: {{ web_dir }}/config/initializers/smtp_settings.rb
{%- endif %}
      - archive: gitlab
  service:
    - running
    - name: gitlab
    - order: 50
    - require:
      - user: gitlab
    - watch:
      - archive: gitlab
      - cmd: gitlab
      - cmd: bundler
      - cmd: gitlab_precompile_assets
      - file: gitlab_upstart
      - file: {{ web_dir }}/config.ru
      - file: {{ web_dir }}/config/gitlab.yml
{%- if salt['pillar.get']('gitlab:smtp:enabled', False) %}
      - file: {{ web_dir }}/config/environments/production.rb
      - file: {{ web_dir }}/config/initializers/smtp_settings.rb
{%- endif %}

gitlab_precompile_assets:
  cmd:
    - wait
    - name: bundle exec rake assets:precompile
    - env:
        RAILS_ENV: production
    - user: {{ user }}
    - cwd: {{ web_dir }}
    - unless: ls {{ web_dir }}/public/assets/
    - watch:
      - cmd: gitlab

{#-
gitlab_start_sidekiq_service:
  cmd:
    - wait
    - name: bundle exec rake sidekiq:start
    - env:
         RAILS_ENV: production
    - user: {{ user }}
    - cwd: {{ web_dir }}
    - unless: ps -ef | grep [s]idekiq
    - watch:
      - cmd: gitlab
#}

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
    - mode: 755

{%- for dir in ('log', 'tmp', 'public/uploads', 'tmp/pids', 'tmp/cache') %}
{{ web_dir }}/{{ dir }}:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - dir_mode: 755
    - file_mode: 644
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
      - file: gitlab_upstart
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

rack:
  gem:
    - installed
    - version: 1.4.5
    - runas: root
    - require:
      - pkg: ruby
      - pkg: build

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
      - uwsgi: gitlab
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
    - mode: 644
    - require:
      - user: {{ user }}

gitlab_upstart:
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

{% from 'rsyslog/upstart.sls' import manage_upstart_log with context %}
{{ manage_upstart_log('gitlab') }}

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
    - mode: 644
    - require:
      - file: gitlab
    - require_in:
      - file: {{ home_dir }}/gitlab-satellites

{%- for file in ('Gemfile', 'Gemfile.lock') %}
{{ web_dir }}/{{ file }}:
  file:
    - managed
    - source: salt://gitlab/{{ file }}
    - user: git
    - group: git
    - mode: 440
    - require:
      - user: gitlab
      - file: gitlab
    - require_in:
      - cmd: bundler
{%- endfor %}

extend:
  web:
    user:
      - groups:
        - git
      - require:
        - user: gitlab
      - watch_in:
        - uwsgi: gitlab
{%- if salt['pillar.get']('gitlab:ssl', False) %}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ pillar['gitlab']['ssl'] }}
{%- endif %}
