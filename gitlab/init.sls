{#-
GitLab: self hosted Git management software
===========================================

Mandatory Pillar
----------------

gitlab:
  hostnames:
    - localhost

Optional Pillar
---------------

gitlab:
  workers: 2
  config:
    port: 80
    ssl: false
    email_from: email_from@localhost
    support_email: support_email@localhost
    default_projects_limit: 10
  database:
    host: localhost
    port: 5432
    username: git
    password: postgres_user_pass
  ldap:
    enabled: false
    host: xxx
    base: xxx
    port: 636
    uid: xxx
    method: plain    # `plain` or `ssl`
    bind_dn: xxx
    password: xxx
    allow_username_or_email_login: true

Note: Before run bundle `git` is root_dir owner
Only `git` user be allowed to run the bundle and setup task
#}

include:
  - apt
  - build
  - git
  - nginx
  - nodejs
  - postgresql.server
  - python
  - ruby
  - redis
{% if salt['pillar.get']('gitlab:config:ssl')|default(False) %}
  - ssl
{% endif %}
  - uwsgi.ruby
  - web


gitlab_dependencies:
  pkg:
    - installed
    - pkgs:
      - adduser
      - libpq-dev
      - libicu-dev
      - libxslt1-dev
      - libcurl4-openssl-dev
    - require:
      - cmd: apt_sources
      - pkg: build
      - pkg: git
      - pkg: python
      - pkg: nodejs

gitlab-shell:
  archive:
    - extracted
    - name: /home/git/
    {%- if 'files_archive' in pillar %}
    - source: {{ salt['pillar.get']('files_archive') }}/mirror/gitlab/shell-fbaf8d8c12dcb9d820d250b9f9589318dbc36616.tar.gz
    - source_hash: md5=fa679c88f382211b34ecd35bfbb54ea6
    {%- else %}
    - source: https://github.com/gitlabhq/gitlab-shell/archive/master.tar.gz
    - source_hash: md5=e852ac69b13ad055424442368282774e
    {%- endif %}
    - archive_format: tar
    - tar_options: z
    - if_missing: /home/git/gitlab-shell
    - require:
      - user: gitlab
  file:
    - directory
    - name: /home/git
    - user: git
    - group: git
    - mode: 775
    - recurse:
      - user
      - group
    - require:
      - cmd: gitlab-shell
  cmd:
    - run
    - name: mv gitlab-shell-master gitlab-shell
    - cwd: /home/git
    - user: git
    - onlyif: ls /home/git/ | grep gitlab-shell-master
    - require:
      - archive: gitlab-shell
    - require_in:
      - file: change_permission_git_home

change_permission_git_home:
  file:
    - directory
    - name: /home/git
    - mode: 775
    - recurse:
      - mode

install_gitlab_shell:
  cmd:
    - run
    - name: /home/git/gitlab-shell/bin/install
    - user: git
    - require:
      - file: /home/git/gitlab-shell/config.yml
      - pkg: ruby

/home/git/gitlab-shell/config.yml:
  file:
    - managed
    - source: salt://gitlab/gitlab-shell.jinja2
    - template: jinja
    - user: git
    - group: git
    - mode: 440
    - require:
      - file: gitlab-shell
      - pkg: ruby

{%- set database_username = salt['pillar.get']('gitlab:database:username','git') %}
{%- set database_password = salt['password.pillar']('gitlab:database:password', 10) %}
{%- set version = '6-0' %}
{%- set root_dir = "/usr/local/gitlabhq-" + version + "-stable"  %}

gitlab:
  user:
    - present
    - name: git
    - shell: /bin/bash
    - require:
      - pkg: gitlab_dependencies
  postgres_user:
    - present
    - name: {{ database_username }}
    - password: {{ database_password }}
    - require:
      - service: postgresql
      - cmd: install_gitlab_shell
  postgres_database:
    - present
    - name: gitlab
    - owner: {{ database_username }}
    - require:
      - postgres_user: gitlab
  archive:
    - extracted
    - name: /usr/local
    {%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/gitlab/{{ version|replace("-", ".") }}.tar.gz
    - source_hash: md5=151be72dc60179254c58120098f2a84e
    {%- else %}
    - source: salt://gitlab/gitlab-{{ version }}.tar.gz
    - source_hash: md5=151be72dc60179254c58120098f2a84e
    {%- endif %}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ root_dir }}
    - require:
      - postgres_database: gitlab
  file:
    - directory
    - name: {{ root_dir }}
    - user: git
    - group: git
    - mode: 775
    - recurse:
      - user
      - group
      - mode
    - require:
      - archive: gitlab
  cmd:
    - run
    - name: export force="yes"; bundle exec rake gitlab:setup RAILS_ENV=production
    #- env:
      #force: yes
    - user: git
    - cwd: {{ root_dir }}
    - require:
      - cmd: bundler
      - service: redis-server

precompile_assets:
  cmd:
    - wait
    - name: bundle exec rake assets:precompile RAILS_ENV=production
    - user: git
    - cwd: {{ root_dir }}
    - watch:
      - file: /etc/nginx/conf.d/gitlab.conf

start_sidekiq_service:
  cmd:
    - wait
    - name: bundle exec rake sidekiq:start RAILS_ENV=production
    - user: git
    - cwd: {{ root_dir }}
    - watch:
      - cmd: precompile_assets

{{ root_dir }}/config.ru:
  file:
    - managed
    - source: salt://gitlab/config.jinja2
    - user: git
    - group: git
    - template: jinja
    - mode: 440
    - require:
      - cmd: gitlab

/home/git/gitlab-satellites:
  file:
    - directory
    - user: git
    - group: git
    - mode: 775

{%- for dir in ('log', 'tmp', 'public/uploads', 'tmp/pids', 'tmp/cache') %}
{{ root_dir }}/{{ dir }}:
  file:
    - directory
    - user: git
    - group: git
    - dir_mode: 775
    - file_mode: 775
    - recurse:
      - user
      - group
      - mode
    - require:
      - file: gitlab
    - require_in:
      - file: /home/git/gitlab-satellites
{%- endfor %}

{%- for file in ('gitlab.yml', 'database.yml') %}
{{ root_dir }}/config/{{ file }}:
  file:
    - managed
    - source: salt://gitlab/{{ file }}.jinja2
    - template: jinja
    - user: git
    - group: git
    - mode: 440
    - require:
      - file: gitlab
    - require_in:
      - file: /home/git/gitlab-satellites
 {%- endfor %}

charlock_holmes:
  gem:
    - installed
    - version: 0.6.9.4
    - runas: root
    - require:
      - file: gitlab
      - file: /home/git/gitlab-satellites

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
    - cwd: {{ root_dir }}
    - user: git
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

add_web_user_to_group:
  user:
    - present
    - name: www-data
    - groups:
      - git
    - require:
      - user: web
      - user: git

/etc/uwsgi/gitlab.ini:
  file:
    - managed
    - source: salt://gitlab/uwsgi.jinja2
    - group: www-data
    - user: www-data
    - template: jinja
    - mode: 440
    - require:
      - cmd: gitlab
      - file: uwsgi_sockets
      - file: uwsgi_emperor
      - gem: rack
      - file: {{ root_dir }}/config.ru
      - user: add_web_user_to_group
    - watch_in:
      - service: uwsgi_emperor
    - context:
      root_dir: {{ root_dir }}

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
      - file: /etc/uwsgi/gitlab.ini
{% if salt['pillar.get']('gitlab:config:ssl')|default(False) %}
      - cmd: /etc/ssl/{{ salt['pillar.get']('gitlab:config:ssl') }}/chained_ca.crt
      - module: /etc/ssl/{{ salt['pillar.get']('gitlab:config:ssl') }}/server.pem
      - file: /etc/ssl/{{ salt['pillar.get']('gitlab:config:ssl') }}/ca.crt
{% endif %}
    - watch_in:
      - service: nginx
    - context:
      root_dir: {{ root_dir }}

/home/git/.gitconfig:
  file:
    - managed
    - source: salt://gitlab/gitconfig.jinja2
    - template: jinja
    - user: git
    - group: git
    - mode: 644
    - require:
      - user: git
