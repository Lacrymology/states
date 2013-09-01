{#-
GitLab: self hosted Git management software
===========================================

Mandatory Pillar
----------------

gitlab:
  hostnames:                # Should not use `localhost`
    - 192.241.189.78

Optional Pillar
---------------

gitlab:
  smtp:
    - enabled: True
    - address: smtp.gmail.com
    - port: 465
    - domain: gmail.com
    - user_name: youruser@yourdomain.com
    - password: password
    - authentication: plain
    - enable_starttls_auto: true
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

{%- set database_username = salt['pillar.get']('gitlab:database:username', 'git') %}
{%- set database_password = salt['password.pillar']('gitlab:database:password', 10) %}

{%- set version = '6-0' %}
{%- set root_dir = "/usr/local" %}
{%- set home_dir = "/home/git" %}
{%- set web_dir = root_dir +  "/gitlabhq-" + version + "-stable"  %}
{%- set repos_dir = home_dir + "/repositories" %}
{%- set shell_dir = home_dir + "/gitlab-shell" %}

gitlab_dependencies:
  pkg:
    - installed
    - pkgs:
      - adduser
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
    - name: {{ home_dir }}/
    {%- if 'files_archive' in pillar %}
    - source: {{ salt['pillar.get']('files_archive') }}/mirror/gitlab/shell-fbaf8d8c12dcb9d820d250b9f9589318dbc36616.tar.gz
    - source_hash: md5=fa679c88f382211b34ecd35bfbb54ea6
    {%- else %}
    - source: https://github.com/gitlabhq/gitlab-shell/archive/master.tar.gz
    - source_hash: md5=e852ac69b13ad055424442368282774e
    {%- endif %}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ shell_dir }}
    - require:
      - user: gitlab
  file:
    - directory
    - name: {{ shell_dir }}
    - user: git
    - group: git
    - recurse:
      - user
      - group
    - require:
      - cmd: gitlab-shell
  cmd:
    - run
    - name: mv gitlab-shell-master gitlab-shell
    - cwd: {{ home_dir }}
    - user: git
    - onlyif: ls {{ home_dir }} | grep gitlab-shell-master
    - require:
      - archive: gitlab-shell

install_gitlab_shell:
  cmd:
    - run
    - name: {{ shell_dir }}/bin/install
    - user: git
    - require:
      - file: {{ shell_dir }}/config.yml
      - pkg: ruby

{{ shell_dir }}/config.yml:
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
    - context:
      repos_dir: {{ repos_dir }}
      shell_dir: {{ shell_dir }}

gitlab:
  user:
    - present
    - name: git
    - groups:
      - www-data
    - shell: /bin/bash
    - require:
      - pkg: gitlab_dependencies
      - user: web
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
    - name: {{ root_dir }}/
    {%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/gitlab/{{ version|replace("-", ".") }}.tar.gz
    - source_hash: md5=151be72dc60179254c58120098f2a84e
    {%- else %}
    - source: salt://gitlab/gitlab-{{ version }}.tar.gz
    - source_hash: md5=151be72dc60179254c58120098f2a84e
    {%- endif %}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_dir }}
    - require:
      - postgres_database: gitlab
      - file: /usr/local
  file:
    - directory
    - name: {{ web_dir }}
    - user: git
    - group: git
    - recurse:
      - user
      - group
    - require:
      - archive: gitlab
  cmd:
    - wait
    - name: force=yes bundle exec rake gitlab:setup RAILS_ENV=production
    - user: git
    - cwd: {{ web_dir }}
    - require:
      - service: redis-server
    - watch:
      - cmd: bundler

precompile_assets:
  cmd:
    - wait
    - name: bundle exec rake assets:precompile RAILS_ENV=production
    - user: git
    - cwd: {{ web_dir }}
    - watch:
      - cmd: gitlab

start_sidekiq_service:
  cmd:
    - wait
    - name: bundle exec rake sidekiq:start RAILS_ENV=production
    - user: git
    - cwd: {{ web_dir }}
    - watch:
      - cmd: gitlab

{{ web_dir }}/config.ru:
  file:
    - managed
    - source: salt://gitlab/config.jinja2
    - user: git
    - group: git
    - template: jinja
    - mode: 440
    - require:
      - cmd: gitlab

{{ home_dir }}/gitlab-satellites:
  file:
    - directory
    - user: git
    - group: git
    - mode: 755

{%- for dir in ('log', 'tmp', 'public/uploads', 'tmp/pids', 'tmp/cache') %}
{{ web_dir }}/{{ dir }}:
  file:
    - directory
    - user: git
    - group: git
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
    - user: git
    - group: git
    - mode: 440
    - require:
      - file: gitlab
    - require_in:
      - file: {{ home_dir }}/gitlab-satellites
    - context:
      home_dir: {{ home_dir }}
      repos_dir: {{ repos_dir }}
      shell_dir: {{ shell_dir }}
 {%- endfor %}

charlock_holmes:
  gem:
    - installed
    - version: 0.6.9.4
    - runas: root
    - require:
      - file: gitlab
      - file: {{ home_dir }}/gitlab-satellites

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
      - user: gitlab

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
      - cmd: start_sidekiq_service
      - cmd: precompile_assets
      - file: uwsgi_sockets
      - file: gitlab_upstart
      - gem: rack
      - file: {{ web_dir }}/config.ru
      - user: add_web_user_to_group
    - watch_in:
      - service: uwsgi_emperor
    - context:
      web_dir: {{ web_dir }}

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
      web_dir: {{ web_dir }}

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
