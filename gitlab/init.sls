{#-
GitLab: self hosted Git management software
===========================================

Optional Pillar
---------------

gitlab:
  config:
    host: localhost
    port: 80
    https: false
    email_from: email_from@localhost
    support_email: support_email@localhost
    default_projects_limit: 10
  database:
    host: localhost
    port: 5432
    username: git
    password: pass    # default password is `pass`
  nginx:
    server_name: localhost

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
  - nginx
  - nodejs
  - postgresql.server
  - ruby
  - redis
  - web

gitlab_dependencies:
  pkg:
    - installed
    - pkgs:
      - adduser
      - libpq-dev
      - libicu-dev
      - libxslt1-dev
    - require:
      - cmd: apt_sources

git:
  user:
    - present
    - shell: /bin/false
    - require:
      - pkg: gitlab_dependencies

gitlab-shell:
  archive:
    - extracted
    - name: /home/git/
    {#- need move to archive!! #}
    {%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/gitlab-shell.tar.gz
    {%- else %}
    - source: salt://gitlab/gitlab-shell.tar.gz
    {%- endif %}
    - source_hash: md5=a0a6fa03552891f002f4f7995995acdd
    - archive_format: tar
    - tar_options: z
    - if_missing: /home/git/gitlab-shell
    - require:
      - user: git
  file:
    - directory
    - name: /home/git/gitlab-shell
    - user: git
    - group: git
    - recurse:
      - user
      - group
    - require:
      - archive: gitlab-shell
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
    - require:
      - file: gitlab-shell
      - pkg: ruby

{%- set database_username = salt['pillar.get']('gitlab:database:username','git') %}
{%- set database_password = salt['pillar.get']('gitlab:database:password','pass') %}
{%- version = '6.0' %}
gitlab:
  postgres_user:
    - present
    - name: {{ database_username }}
    - password: {{ database_password }}
    - require:
      - service: postgresql
      - cmd: gitlab-shell
  postgres_database:
    - present
    - name: gitlab
    - owner: {{ database_username }}
    - require:
      - postgres_user: gitlab
  archive:
    - extracted
    - name: /home/git/
    {#- need move to archive!! #}
    {%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/gitlab-{{ version }}.tar.gz
    {%- else %}
    - source: salt://gitlab/gitlab-{{ version }}.tar.gz
    {%- endif %}
    - source_hash: md5=be9dba08988aa5ae1108bbdf76359896
    - archive_format: tar
    - tar_options: z
    - if_missing: /home/git/gitlab
    - require:
      - postgres_database: gitlab
  file:
    - directory
    - name: /home/git/gitlab
    - user: git
    - group: git
    - recurse:
      - user
      - group
    - require:
      - archive: gitlab

/home/git/gitlab-satellites:
    file:
      - directory
      - user: git
      - group: git

{%- for dir in 'log', 'tmp', 'tmp/pids', 'tmp/sockets', 'public/uploads' %}
/home/git/gitlab/{{ dir }}:
  file:
    - directory
    - user: git
    - group: git
    - dir_mode: 700
    - file_mode: 700
    - recurse:
      - user
      - group
      - mode
    - require:
      - file: gitlab
    - require_in:
      - file: /home/git/gitlab-satellites
{%- endfor %}

{%- for file in 'unicorn.rb', 'gitlab.yml', 'database.yml', 'puma.rb' %}
/home/git/gitlab/config/{{ file }}:
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

{#
gem_depends:
  pkg:
    - installed
    - pkgs:
      {%- for pkg in 'libpq-dev', 'libicu-dev', 'libxml2-dev', 'libxslt1-dev' %}
      - {{ pkg }}
      {%- endfor %}
    - require:
      - file: /home/git/gitlab-satellites
      #}
charlock_holmes:
  gem:
    - installed
    - version: 0.6.9.4
    - require:
      - file: gitlab

bundle:
  gem:
    - installed
    - version: 1.3.5
    - require:
      - gem: charlock_holmes
  cmd:
    - run
    - name: bundle install --deployment --without development test mysql unicorn aws
    - cwd: /home/git/gitlab
    - user: git
    - require:
      - gem: bundle

create_database:
  cmd:
    - run
    - name: export force="yes"; bundle exec rake gitlab:setup RAILS_ENV=production
    - user: git
    - cwd: /home/git/gitlab
    - require:
      - cmd: bundle
      - service: redis-server

gitlab:
  file:
    - managed
    - name: /etc/init.d/gitlab
    - source: salt://gitlab/gitlab.init.jinja2
    - template: jinja
    - mode: 500
    - require:
      - cmd: create_database
  cmd:
    - run
    - name: update-rc.d gitlab defaults 21
    - require:
      - file: gitlab
  service:
    - running
    - require:
      - pkg: nodejs
      - cmd: gitlab


/etc/nginx/conf.d/gitlab.conf:
  file:
    - managed
    - source: salt://gitlab/nginx.jinja2
    - template: jinja
    - require:
      - pkg: nginx
      - service: gitlab

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/gitlab.conf

#}
