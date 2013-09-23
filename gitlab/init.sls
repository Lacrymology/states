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
    enabled: Default is False

  workers: 2
  ssl: enable ssl. Default: False
  port: port to run gitlab web. Default: 80
  support_email: your support email
  default_projects_limit: 10

  database:
    host: localhost
    port: 5432
    username: postgre user. Default is gitlab
    password: password for postgre user
  ldap:
    enabled: enable ldap auth, Default: False

If you set gitlab:ldap:enabled is True, you must define:
gitlab:
  ldap:
    host: ldap ldap server, Ex: ldap.yourdomain.com
    base: the base where your search for users. Ex: dc=yourdomain,dc=com
    port: Default is 636 for `plain` method
    uid: sAMAccountName
    method: plain    # `plain` or `ssl`
    bind_dn: binddn of user your will bind with. Ex: cn=vmail,dc=yourdomain,dc=com
    password: password of bind user
    allow_username_or_email_login: use name instead of email for login. Default: true

If you set gitlab:smtp:enabled is True, you must define:
gitlab
  smtp:
    default: use default settings, it mean that you don't need declare all values below. Default is True
    server: your smtp server. Ex: smtp.yourdomain.com
    port: smtp server port
    domain: your email domain
    from: smtp account will sent email to users
    user: account login
    password: password for account login
    authentication: Default is: `plain`  for most smtp servers (like Gmail...)
    tls: Default is: False
#}

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
  - ruby
  - redis
{%- if salt['pillar.get']('gitlab:ssl', False) %}
  - ssl
{%- endif %}
  - uwsgi.ruby
  - web
  - xml

{%- set database_username = salt['pillar.get']('gitlab:database:username', 'gitlab') %}
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
    - source: {{ salt['pillar.get']('files_archive')|replace('file://', '') }}/mirror/gitlab/shell-fbaf8d8c12dcb9d820d250b9f9589318dbc36616.tar.gz
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
    - source: {{ pillar['files_archive']|replace('file://', '') }}/mirror/gitlab/{{ version|replace("-", ".") }}.tar.gz
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
    - user: git
    - group: git
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
    - user: git
    - cwd: {{ web_dir }}
    - require:
      - service: redis
    - watch:
      - cmd: bundler

gitlab_precompile_assets:
  cmd:
    - wait
    - name: bundle exec rake assets:precompile
    - env:
        RAILS_ENV: production
    - user: git
    - cwd: {{ web_dir }}
    - watch:
      - cmd: gitlab

gitlab_start_sidekiq_service:
  cmd:
    - wait
    - name: bundle exec rake sidekiq:start
    - env:
         RAILS_ENV: production
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

add_web_user_to_git_group:
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
      - cmd: gitlab_start_sidekiq_service
      - cmd: gitlab_precompile_assets
      - service: uwsgi_emperor
      - file: gitlab_upstart
      - gem: rack
      - file: {{ web_dir }}/config.ru
      - user: add_web_user_to_git_group
      - postgres_database: gitlab
    - context:
      web_dir: {{ web_dir }}
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/gitlab.ini
    - require:
      - file: /etc/uwsgi/gitlab.ini
    - watch:
      - file: {{ web_dir }}/config/gitlab.yml
      - file: {{ web_dir }}/config/database.yml
{%- if salt['pillar.get']('gitlab:smtp:enabled', False) %}
      - file: {{ web_dir }}/config/environments/production.rb
      - file: {{ web_dir }}/config/initializers/smtp_settings.rb
{%- endif %}
      - archive: gitlab

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
{%- if salt['pillar.get']('gitlab:ssl', False) %}
      - cmd: /etc/ssl/{{ salt['pillar.get']('gitlab:ssl') }}/chained_ca.crt
      - module: /etc/ssl/{{ salt['pillar.get']('gitlab:ssl') }}/server.pem
      - file: /etc/ssl/{{ salt['pillar.get']('gitlab:ssl') }}/ca.crt
{%- endif %}
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

{%- if salt['pillar.get']('gitlab:smtp:enabled', False) %}
{{ web_dir }}/config/environments/production.rb:
  file:
    - managed
    - source: salt://gitlab/production.jinja2
    - user: git
    - group: git
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
    - user: git
    - group: git
    - template: jinja
    - mode: 440
    - require:
      - user: gitlab
      - file: gitlab
    - require_in:
      - cmd: bundler
{%- endif %}

{%- if salt['pillar.get']('gitlab:ssl', False) %}
extend:
  nginx:
    service:
      - watch:
        - cmd: /etc/ssl/{{ salt['pillar.get']('gitlab:ssl') }}/chained_ca.crt
        - module: /etc/ssl/{{ salt['pillar.get']('gitlab:ssl') }}/server.pem
        - file: /etc/ssl/{{ salt['pillar.get']('gitlab:ssl') }}/ca.crt
{%- endif %}
