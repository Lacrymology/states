{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context %}
{%- set ssl = salt['pillar.get']('gitlab:ssl', False) %}
{%- set gem_source = salt["pillar.get"]("gem_source", "https://rubygems.org") %}
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- set mirror = files_archive if files_archive else "http://archive.robotinfra.com" %}
{%- set incoming_email = salt["pillar.get"]("gitlab:incoming_email", False) %}
include:
  - apt
  - build
  - git
  - logrotate
  - nginx
  - nodejs
  - postgresql.server
  - python
  - redis
  - ruby.2
  - ssh.server
  - ssl.dev
  - sudo
  - web
  - xml
  - yaml
{%- if ssl %}
  - ssl
{%- endif %}

{%- set version = "8.1.4" %}
{%- set hash = "md5=3782527645a8baf62da8a4f9caf1f421" %}
{%- set gitlab_shell_version = "2.6.6" %}
{%- set gitlab_git_http_server_version = "0.3.0" %}

{%- if grains["osarch"] == "amd64" %}
  {%- set goarch = "amd64" %}
  {%- set gitlab_git_http_server_hash = "md5=e3bc8da0b0103907b0e97021e66a9454" %}
{%- elif grains["osarch"] == "amd64" %}
  {%- set goarch = "386" %}
  {%- set gitlab_git_http_server_hash = "md5=bf1dd0c3fd29fd56d41c757d8ccf02b7" %}
{%- endif %}
{%- set gitlab_git_http_server_source =
  "%s/mirror/gitlab/gitlab-git-http-server-%s-%s.tar.bz2" %
  (mirror, gitlab_git_http_server_version, goarch)
%}

gitlab_dependencies:
  pkg:
    - installed
    - pkgs:
      - build-essential
      - checkinstall
      - cmake
      - curl
      - libcurl4-openssl-dev
      - libffi-dev
      - libgdbm-dev
      - libicu-dev
      - libncurses5-dev
      - libreadline-dev
      - pkg-config
      - python-docutils
    - require:
      - pkg: postgresql-dev
      - cmd: apt_sources
      - pkg: build

gitlab:
  user:
    - present
    - name: gitlab
    - groups:
      - www-data
      - redis
    - shell: /bin/bash
    - require:
      - pkg: gitlab_dependencies
      - pkg: redis
      - user: web
  postgres_user:
    - present
    - name: gitlab
    - createdb: True
    - password: {{ salt['password.pillar']('gitlab:db:password') }}
    - require:
      - service: postgresql
      - user: gitlab
  postgres_database:
    - present
    - name: gitlabhq_production
    - owner: gitlab
    - require:
      - postgres_user: gitlab
  archive:
    - extracted
    - name: /home/gitlab
{%- if files_archive %}
    - source: {{ files_archive }}/mirror/gitlab/gitlabhq-{{ version }}.tar.gz
{%- else %}
    - source: https://github.com/gitlabhq/gitlabhq/archive/v{{ version }}.tar.gz
{%- endif %}
    - source_hash: {{ hash }}
    - archive_format: tar
    - tar_options: z
    - if_missing: /home/gitlab/gitlabhq-{{ version }}
    - require:
      - postgres_database: gitlab
  cmd:
    - wait
    - name: bundle exec rake gitlab:setup
    - env:
      - force: "yes"
      - RAILS_ENV: production
      - GITLAB_ROOT_PASSWORD: "{{ salt['pillar.get']('gitlab:admin:password') }}"
    - user: gitlab
    - cwd: /home/gitlab/gitlabhq-{{ version }}
    - require:
      - file: gitlab_shell
      - service: redis
      - cmd: gitlab_gems
      - file: gitlabhq-{{ version }}
      - file: /home/gitlab/gitlabhq-{{ version }}/config/database.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/log
    - watch:
      - postgres_database: gitlab

gitlab_sidekiq:
  file:
    - managed
    - name: /etc/init/gitlab-sidekiq.conf
    - source: salt://gitlab/upstart-sidekiq.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        version: {{ version }}
    - require:
      - file: gitlabhq-{{ version }}
  service:
    - running
    - name: gitlab-sidekiq
    - watch:
      - archive: gitlab
      - cmd: gitlab
      - cmd: gitlab_gems
      - file: /home/gitlab/gitlabhq-{{ version }}/config/resque.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/log
      - file: gitlab_sidekiq
      - user: gitlab

gitlabhq-{{ version }}:
  file:
    - directory
    - name: /home/gitlab/gitlabhq-{{ version }}
    - user: gitlab
    - group: gitlab
    - recurse:
      - user
      - group
    - require:
      - archive: gitlab

/home/gitlab/gitlabhq-{{ version }}/config/gitlab.yml:
  file:
    - managed
    - source: salt://gitlab/gitlab.jinja2
    - template: jinja
    - user: root
    - group: gitlab
    - mode: 440
    - require:
      - file: gitlabhq-{{ version }}
      - file: /var/lib/gitlab

/home/gitlab/gitlabhq-{{ version }}/config/secrets.yml:
  file:
    - managed
    - source: salt://gitlab/secrets.jinja2
    - template: jinja
    - user: root
    - group: gitlab
    - mode: 440
    - context:
        db_key_base: {{ salt["pillar.get"]("gitlab:db_key_base") }}
    - require:
      - file: gitlabhq-{{ version }}

/home/gitlab/gitlabhq-{{ version }}/config/unicorn.rb:
  file:
    - managed
    - source: salt://gitlab/unicorn.jinja2
    - template: jinja
    - user: root
    - group: gitlab
    - mode: 440
    - context:
        version: {{ version }}
    - require:
      - file: gitlabhq-{{ version }}

/home/gitlab/gitlabhq-{{ version }}/config/initializers/rack_attack.rb:
  file:
    - managed
    - source: salt://gitlab/rack_attack.rb.jinja2
    - template: jinja
    - user: root
    - group: gitlab
    - mode: 440
    - require:
      - file: gitlabhq-{{ version }}

/home/gitlab/gitlabhq-{{ version }}/config/resque.yml:
  file:
    - managed
    - source: salt://gitlab/resque.jinja2
    - template: jinja
    - user: root
    - group: gitlab
    - mode: 440
    - require:
      - file: gitlabhq-{{ version }}

/home/gitlab/gitlabhq-{{ version }}/config/database.yml:
  file:
    - managed
    - source: salt://gitlab/database.jinja2
    - template: jinja
    - user: root
    - group: gitlab
    - mode: 440
    - require:
      - file: gitlabhq-{{ version }}

/home/gitlab/.gitconfig:
  file:
    - managed
    - source: salt://gitlab/gitconfig.jinja2
    - template: jinja
    - user: root
    - group: gitlab
    - mode: 440
    - require:
        - file: gitlabhq-{{ version }}

/home/gitlab/gitlabhq-{{ version }}/config/environments/production.rb:
  file:
    - managed
    - source: salt://gitlab/production.rb
    - user: root
    - group: gitlab
    - template: jinja
    - mode: 440
    - require:
      - user: gitlab
      - file: gitlabhq-{{ version }}
    - require_in:
      - cmd: gitlab_gems

/home/gitlab/gitlabhq-{{ version }}/config/initializers/smtp_settings.rb:
  file:
    - managed
    - source: salt://gitlab/smtp.jinja2
    - user: root
    - group: gitlab
    - template: jinja
    - mode: 440
    - require:
      - user: gitlab
      - file: gitlabhq-{{ version }}
    - require_in:
      - cmd: gitlab_gems

/home/gitlab/gitlabhq-{{ version }}/db/fixtures/production/001_admin.rb:
  file:
    - managed
    - source: salt://gitlab/admin.jinja2
    - user: root
    - group: gitlab
    - template: jinja
    - mode: 440
    - require:
      - user: gitlab
      - file: gitlabhq-{{ version }}
    - require_in:
      - cmd: gitlab_gems

{%- for file in ["Gemfile", "Gemfile.lock"] %}
/home/gitlab/gitlabhq-{{ version }}/{{ file }}:
  file:
    - managed
    - source: salt://gitlab/{{ file }}.jinja2
    - user: root
    - group: gitlab
    - template: jinja
    - mode: 440
    - require:
      - user: gitlab
      - file: gitlabhq-{{ version }}
    - context:
        gem_source: {{ gem_source }}
    - require:
      - file: gitlabhq-{{ version }}
    - require_in:
      - cmd: gitlab_gems
{%- endfor %}

gitlab_gems:
  cmd:
    - wait
    - name: >-
        bundle install -j {{ grains["num_cpus"] }}
        --deployment --without development test mysql aws kerberos
    - user: gitlab
    - cwd: /home/gitlab/gitlabhq-{{ version }}
    - require:
      - gem: ruby2
    - watch:
      - archive: gitlab

gitlab_shell:
  cmd:
    - wait
    - name: bundle exec rake gitlab:shell:install[v{{ gitlab_shell_version}}]
    - user: gitlab
    - cwd: /home/gitlab/gitlabhq-{{ version }}
    - env:
      - REDIS_URL: unix:/var/run/redis/redis.sock
      - RAILS_ENV: production
    - require:
      - cmd: gitlab_gems
      - file: /var/log/gitlab/gitlab-shell
      - file: /home/gitlab/gitlabhq-{{ version }}/log
      - pkg: git
    - watch:
      - archive: gitlab
      - file: /home/gitlab/gitlabhq-{{ version }}/config/database.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/config/gitlab.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/config/initializers/rack_attack.rb
      - file: /home/gitlab/gitlabhq-{{ version }}/config/resque.yml
  file:
    - managed
    - name: /home/gitlab/gitlab-shell/config.yml
    - source: salt://gitlab/gitlab-shell.jinja2
    - template: jinja
    - user: gitlab
    - group: gitlab
    - mode: 640  {# gitlab_shell setup needs write permission #}
    - require:
      - file: /var/log/gitlab/gitlab-shell
      - cmd: gitlab_shell

/etc/nginx/conf.d/gitlab.conf:
  file:
    - managed
    - source: salt://gitlab/nginx.jinja2
    - template: jinja
    - user: root
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - user: web
{%- if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{%- endif %}
    - watch_in:
      - service: nginx
    - context:
        version: {{ version }}

gitlab_precompile_assets:
  cmd:
    - wait
    - name: bundle exec rake assets:precompile
    - env:
        RAILS_ENV: production
    - user: gitlab
    - cwd: /home/gitlab/gitlabhq-{{ version }}
    - unless: test -d /home/gitlab/gitlabhq-{{ version }}/public/assets/
    - require:
      - pkg: nodejs
    - watch:
      - cmd: gitlab
      - cmd: gitlab_gems

/var/log/gitlab:
  file:
    - directory
    - user: gitlab
    - group: gitlab
    - require:
      - user: gitlab

/var/log/gitlab/gitlabhq:
  file:
    - directory
    - user: gitlab
    - group: gitlab
    - require:
      - file: /var/log/gitlab

/var/log/gitlab/gitlab-shell:
  file:
    - directory
    - user: gitlab
    - group: gitlab
    - require:
      - file: /var/log/gitlab

/home/gitlab/gitlabhq-{{ version }}/log:
  file:
    - symlink
    - target: /var/log/gitlab/gitlabhq
    - force: True
    - user: gitlab
    - group: gitlab
    - require:
      - file: /var/log/gitlab/gitlabhq
      - file: gitlabhq-{{ version }}

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
    - context:
        version: {{ version }}

/var/lib/gitlab:
  file:
    - directory
    - user: gitlab
    - group: gitlab
    - require:
      - user: gitlab

gitlab_unicorn:
  file:
    - managed
    - name: /etc/init/gitlab-unicorn.conf
    - source: salt://gitlab/upstart-unicorn.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        version: {{ version }}
    - require:
      - file: gitlabhq-{{ version }}
      - pkg: sudo
  service:
    - running
    - name: gitlab-unicorn
    - watch:
      - archive: gitlab
      - cmd: gitlab
      - cmd: gitlab_gems
      - file: /home/gitlab/gitlabhq-{{ version }}/config/database.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/config/environments/production.rb
      - file: /home/gitlab/gitlabhq-{{ version }}/config/gitlab.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/config/initializers/rack_attack.rb
      - file: /home/gitlab/gitlabhq-{{ version }}/config/initializers/smtp_settings.rb
      - file: /home/gitlab/gitlabhq-{{ version }}/config/unicorn.rb
      - file: /home/gitlab/gitlabhq-{{ version }}/config/secrets.yml
      - file: gitlab_unicorn
      - postgres_database: gitlab
      - user: web

/usr/local/gitlab-git-http-server:
  file:
    - directory
    - user: root
    - group: root
    - mode: 555
    - require:
      - file: /usr/local

/usr/local/gitlab-git-http-server/{{ gitlab_git_http_server_version }}:
  file:
    - directory
    - user: root
    - group: root
    - mode: 555
    - require:
      - file: /usr/local/gitlab-git-http-server

gitlab_git_http_server:
  archive:
    - extracted
    - name: /usr/local/gitlab-git-http-server/{{ gitlab_git_http_server_version }}
    - source: {{ gitlab_git_http_server_source }}
    - source_hash: {{ gitlab_git_http_server_hash }}
    - archive_format: tar
    - tar_options: oj
    - if_missing: /usr/local/gitlab-git-http-server/{{ gitlab_git_http_server_version }}/gitlab-git-http-server
    - require:
      - file: /usr/local/gitlab-git-http-server
  file:
    - managed
    - name: /etc/init/gitlab-git-http-server.conf
    - source: salt://gitlab/upstart-gitlab-git-http-server.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        version: {{ gitlab_git_http_server_version }}
    - require:
      - file: gitlabhq-{{ version }}
      - pkg: sudo
  service:
    - running
    - name: gitlab-git-http-server
    - require:
      - service: gitlab-unicorn
    - watch:
      - archive: gitlab_git_http_server
      - file: gitlab_git_http_server
      - user: web

{%-  if incoming_email %}
gitlab_mail_room:
  file:
    - managed
    - name: /etc/init/gitlab-mail-room.conf
    - source: salt://gitlab/upstart-mail-room.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        version: {{ version }}
    - require:
      - file: gitlabhq-{{ version }}
  service:
    - running
    - name: gitlab-mail-room
    - watch:
      - cmd: gitlab
      - cmd: gitlab_gems
      - file: /home/gitlab/gitlabhq-{{ version }}/config/resque.yml
      - file: gitlab_mail_room
      - user: gitlab
{%- else %}
{{ upstart_absent('gitlab-mail-room') }}
{%- endif %}

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
