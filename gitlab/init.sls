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
    password: pass    # default password is `pass`

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
  - nginx
  - nodejs
  - postgresql.server
  - python
  - ruby
  - redis
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
      - pkg: python
      - pkg: nodejs

gitlab-shell:
  archive:
    - extracted
    - name: /home/git/
    {#- need move to archive!! #}
    {%- if 'files_archive' in pillar %}
    - source: https://github.com/gitlabhq/gitlab-shell/archive/master.tar.gz
    {%- else %}
    - source: {{ salt['pillar.get']('files_archive') }}/gitlab-shell.tar.gz
    {%- endif %}
    - source_hash: md5=e852ac69b13ad055424442368282774e
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
    - recurse:
      - user
      - group
    - require:
      - cmd: gitlab-shell
      - user: web
  cmd:
    - run
    - name: mv gitlab-shell-master gitlab-shell
    - cwd: /home/git
    - onlyif: ls /home/git/ | grep gitlab-shell-master
    - require:
      - archive: gitlab-shell

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
{%- set database_password = salt['pillar.get']('gitlab:database:password','pass') %}
{%- set version = '6-0' %}
gitlab:
  user:
    - present
    - name: git
    - shell: /bin/false
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
    - name: /home/git/
    {#- need move to archive!! #}
    {%- if 'files_archive' in pillar %}
    - source: https://github.com/gitlabhq/gitlabhq/archive/6-0-stable.tar.gz
    {%- else %}
    - source: salt://gitlab/gitlab-{{ version }}.tar.gz
    {%- endif %}
    - source_hash: md5=ae96d3ed872e664ae9d1d796e3a4efee
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
  cmd:
    - run
    - name: export force="yes"; bundle exec rake gitlab:setup RAILS_ENV=production
    #- env:
      #force: yes
    - user: git
    - cwd: /home/git/gitlab
    - require:
      - cmd: bundler
      - service: redis-server

rename_gitlab:
  cmd:
    - run
    - name: mv gitlabhq-{{ version }}-stable gitlab
    - cwd: /home/git
    - onlyif: ls /home/git | grep gitlabhq-{{ version }}-stable
    - require:
      - archive: gitlab
    - require_in:
      - file: gitlab

change_gitlab_dir_permission:
  cmd:
    - wait
    - name: chown -R www-data:www-data /home/git/gitlab
    - watch:
      - cmd: gitlab
    - require:
      - user: web


/home/git/gitlab-satellites:
    file:
      - directory
      - user: git
      - group: git

{%- for dir in ('log', 'tmp', 'public/uploads') %}
/home/git/gitlab/{{ dir }}:
  file:
    - directory
    - user: git
    - group: git
    - dir_mode: 755
    - file_mode: 755
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
    - cwd: /home/git/gitlab
    - user: git
    - require:
      - gem: bundler

rack:
  gem:
    - installed
    - version: 1.4.5

/etc/uwsgi/gitlab.ini:
  file:
    - managed
    - source: salt://gitlab/uwsgi.jinja2
    - group: www-data
    - user: www-data
    - template: jinja
    - mode: 640 # set mode to 440 after write done
    - require:
      - cmd: gitlab
      - service: uwsgi_emperor
      - gem: rack
      - cmd: change_gitlab_dir_permission
      #- watch_in:
        #- service: uwsgi

/etc/nginx/conf.d/gitlab.conf:
  file:
    - managed
    - source: salt://gitlab/nginx.jinja2
    - template: jinja
    - group: www-data
    - user: www-data
    - mode: 640 # set mode to 440 after write done
    - require:
      - pkg: nginx
      - user: web
      - file: /etc/uwsgi/gitlab.ini
    - watch_in:
      - service: nginx
