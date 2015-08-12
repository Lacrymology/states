{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set ssl = salt['pillar.get']('gitlab:ssl', False) %}
{%- set gem_source = salt["pillar.get"]("gem_source", "https://rubygems.org") %}
include:
  - apt
  - build
  - git
  - logrotate
  - nginx
  - postgresql.server
  - python
  - redis
  - ruby.2
  - ssh.server
{%- if ssl %}
  - ssl
{%- endif %}
  - ssl.dev
  - uwsgi.ruby2
  - web
  - xml
  - yaml

{%- set version = '7.3.2' %}
{%- set gitlab_shell_version = '2.0.1' %}

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
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - source: {{ files_archive }}/mirror/gitlab-{{ version }}.tar.gz
{%- else %}
    - source: https://github.com/gitlabhq/gitlabhq/archive/v{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=e8e83ec258f621edea4214d3c0330c87
    - archive_format: tar
    - tar_options: z
    - if_missing: /home/gitlab/gitlabhq-{{ version }}
    - require:
      - postgres_database: gitlab
  file:
    - managed
    - name: /etc/init/gitlab.conf
    - source: salt://gitlab/upstart.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        version: {{ version }}
    - require:
      - file: gitlabhq-{{ version }}
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
  service:
    - running
    - require:
      - user: gitlab
    - watch:
      - archive: gitlab
      - cmd: gitlab
      - cmd: gitlab_gems
      - file: gitlab
      - file: /home/gitlab/gitlabhq-{{ version }}/config/database.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/config/gitlab.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/config/initializers/rack_attack.rb
      - file: /home/gitlab/gitlabhq-{{ version }}/config/resque.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/log
      - file: /home/gitlab/gitlabhq-{{ version }}/config/environments/production.rb
      - file: /home/gitlab/gitlabhq-{{ version }}/config/initializers/smtp_settings.rb

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

/home/gitlab/gitlab-satellites:
  file:
    - directory
    - user: gitlab
    - group: gitlab
    - mode: 750
    - require:
      - user: gitlab

/home/gitlab/gitlabhq-{{ version }}/config/gitlab.yml:
  file:
    - managed
    - source: salt://gitlab/gitlab.jinja2
    - template: jinja
    - user: gitlab
    - group: gitlab
    - mode: 440
    - require:
      - file: gitlabhq-{{ version }}
      - file: /var/lib/gitlab

/home/gitlab/gitlabhq-{{ version }}/config/initializers/rack_attack.rb:
  file:
    - managed
    - source: salt://gitlab/rack_attack.rb.jinja2
    - template: jinja
    - user: gitlab
    - group: gitlab
    - mode: 440
    - require:
      - file: gitlabhq-{{ version }}

/home/gitlab/gitlabhq-{{ version }}/config/resque.yml:
  file:
    - managed
    - source: salt://gitlab/resque.jinja2
    - template: jinja
    - user: gitlab
    - group: gitlab
    - mode: 440
    - require:
      - file: gitlabhq-{{ version }}

/home/gitlab/gitlabhq-{{ version }}/config/database.yml:
  file:
    - managed
    - source: salt://gitlab/database.jinja2
    - template: jinja
    - user: gitlab
    - group: gitlab
    - mode: 440
    - require:
      - file: gitlabhq-{{ version }}

/home/gitlab/.gitconfig:
  file:
    - managed
    - source: salt://gitlab/gitconfig.jinja2
    - template: jinja
    - user: gitlab
    - group: gitlab
    - mode: 440
    - require:
        - file: gitlabhq-{{ version }}

/home/gitlab/gitlabhq-{{ version }}/config/environments/production.rb:
  file:
    - managed
    - source: salt://gitlab/production.rb
    - user: gitlab
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
    - user: gitlab
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
    - user: gitlab
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
    - user: gitlab
    - group: gitlab
    - template: jinja
    - mode: 440
    - require:
      - user: gitlab
      - file: gitlabhq-{{ version }}
    - context:
        gem_source: {{ gem_source }}
    - require_in:
      - cmd: gitlab_gems
{%- endfor %}

gitlab_gems:
  cmd:
    - wait
    - name: bundle install --deployment --without development test mysql aws
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

gitlab-uwsgi:
  file:
    - managed
    - name: /etc/uwsgi/gitlab.yml
    - source: salt://gitlab/uwsgi.jinja2
    - template: jinja
    - user: root
    - group: gitlab
    - mode: 440
    - context:
        appname: gitlab
        chdir: /home/gitlab/gitlabhq-{{ version }}
        rack: config.ru
        uid: gitlab
        gid: gitlab
    - require:
      - file: gitlabhq-{{ version }}
      - file: gitlab_shell
      - service: uwsgi
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/gitlab.yml
    - require:
      - file: gitlab-uwsgi
    - watch:
      - cmd: gitlab_gems
      - file: gitlab_shell
      - file: /home/gitlab/gitlabhq-{{ version }}/config/database.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/config/gitlab.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/config/initializers/rack_attack.rb
      - file: /home/gitlab/gitlabhq-{{ version }}/config/resque.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/log
      - user: gitlab

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
      - file: gitlab-uwsgi
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
      - archive: gitlab

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
        version: {{ version }}

/var/lib/gitlab:
  file:
    - directory
    - user: gitlab
    - group: gitlab
    - require:
      - user: gitlab

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
