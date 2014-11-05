{#-
Copyright (c) 2014, Diep Pham
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Diep Pham <favadi@robotinfra.com>
Maintainer: Diep Pham <favadi@robotinfra.com>

Install gitlab
-#}

include:
  - apt
  - build
  - git
  - logrotate
  - nginx
  - postgresql.server
  - python
  - redis
  - rsyslog
  - ruby.2
  - ssh.server
{%- if salt['pillar.get']('gitlab:ssl', False) %}
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
      - zlib1g-dev
    - require:
      - pkg: postgresql-dev
      - cmd: apt_sources

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
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/gitlab-{{ version }}.tar.gz
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
    - directory
    - name: /home/gitlab/gitlabhq-{{ version }}
    - user: gitlab
    - group: gitlab
    - recurse:
      - user
      - group
    - require:
      - archive: gitlab
  cmd:
    - wait
    - name: bundle exec rake gitlab:setup
    - env:
      - force: "yes"
      - RAILS_ENV: production
      - GITLAB_ROOT_PASSWORD: "{{ pillar['gitlab']['admin']['password'] }}"
    - user: gitlab
    - cwd: /home/gitlab/gitlabhq-{{ version }}
    - require:
      - file: gitlab_shell
      - service: redis
      - cmd: gitlab_gems
      - file: gitlab
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
      - file: gitlab_upstart
      - file: /home/gitlab/gitlabhq-{{ version }}/config/database.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/config/gitlab.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/config/initializers/rack_attack.rb
      - file: /home/gitlab/gitlabhq-{{ version }}/config/resque.yml
      - file: /home/gitlab/gitlabhq-{{ version }}/log
      - file: /home/gitlab/gitlabhq-{{ version }}/config/environments/production.rb
      - file: /home/gitlab/gitlabhq-{{ version }}/config/initializers/smtp_settings.rb

gitlab_upstart:
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
      - file: gitlab

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
      - file: gitlab
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
      - file: gitlab

/home/gitlab/gitlabhq-{{ version }}/config/resque.yml:
  file:
    - managed
    - source: salt://gitlab/resque.jinja2
    - template: jinja
    - user: gitlab
    - group: gitlab
    - mode: 440
    - require:
      - file: gitlab

/home/gitlab/gitlabhq-{{ version }}/config/database.yml:
  file:
    - managed
    - source: salt://gitlab/database.jinja2
    - template: jinja
    - user: gitlab
    - group: gitlab
    - mode: 440
    - require:
      - file: gitlab

/home/gitlab/.gitconfig:
  file:
    - managed
    - source: salt://gitlab/gitconfig.jinja2
    - template: jinja
    - user: gitlab
    - group: gitlab
    - mode: 440
    - require:
        - file: gitlab

/home/gitlab/gitlabhq-{{ version }}/config/environments/production.rb:
  file:
    - managed
    - source: salt://gitlab/production.rb
    - user: gitlab
    - group: gitlab
    - mode: 440
    - require:
      - user: gitlab
      - file: gitlab
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
      - file: gitlab
    - require_in:
      - cmd: gitlab_gems

gitlab_gems:
  gem:
    - installed
    - name: bundler
    - version: 1.7.3
    - user: root
    - require:
      - pkg: ruby2
  cmd:
    - wait
    - name: bundle install --deployment --without development test mysql aws
    - user: gitlab
    - cwd: /home/gitlab/gitlabhq-{{ version }}
    - require:
      - gem: gitlab_gems
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
    - user: gitlab
    - group: gitlab
    - mode: 440
    - context:
      appname: gitlab
      chdir: /home/gitlab/gitlabhq-{{ version }}
      rack: config.ru
      uid: gitlab
      gid: gitlab
    - require:
      - file: gitlab
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
      - file: gitlab_upstart
    - context:
      version: {{ version }}

/var/lib/gitlab:
  file:
    - directory
    - user: gitlab
    - group: gitlab
    - require:
      - user: gitlab

{%- if salt['pillar.get']('gitlab:ssl', False) %}
extend:
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ pillar['gitlab']['ssl'] }}
{%- endif %}
