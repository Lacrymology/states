{#-
Install Discourse - Discussion Platform
=================


#}

include:
  - apt
  - nginx
  - postgresql
  - postgresql.server
  - redis
  - ruby
  - xml
  - uwsgi.ruby

{%- set web_root_dir = "/usr/local/discourse-master" %}
{%- set password = salt['password.pillar']('discourse:database:password', 10) %}

discourse_deps:
  pkg:
    - installed
    - pkgs:
      - libssl-dev
      - build-essential
      - libtool
      - gawk
      - curl
      - pngcrush
      - imagemagick
    - require:
      - pkg: xml-dev
      - pkg: postgresql-dev
      - pkg: ruby

discourse_tar:
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
    - source: https://github.com/discourse/discourse/archive/master.tar.gz
    - source_hash: md5=ecfb01f1756faa5cd8df25b66f2205c2
{%- else %}
    - source: https://github.com/discourse/discourse/archive/master.tar.gz
    - source_hash: md5=5ea1b394f08131267d92c6bb8f5693e5
{%- endif %}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_root_dir }}
    - require:
      - file: /usr/local
  file:
    - directory
    - name: {{ web_root_dir }}
    - user: discourse
    - group: discourse
    - recurse:
      - user
      - group
    - require:
      - user: discourse
      - archive: discourse_tar

discourse:
  user:
    - present
    - name: discourse
    - require:
      - pkg: discourse_deps
  postgres_user:
    - present
    - name: discourse
    - password: {{ password }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: discourse
    - owner: discourse
    - runas: postgres
    - require:
      - postgres_user: discourse

{{ web_root_dir }}/config/database.yml:
  file:
    - managed
    - source: salt://discourse/database.jinja2
    - template: jinja
    - user: discourse
    - group: discourse
    - mode: 440
    - require:
      - user: discourse
      - file: discourse_tar
    - context:
      password: {{ password }}

{{ web_root_dir }}/config/redis.yml:
  file:
    - managed
    - source: salt://discourse/redis.jinja2
    - template: jinja
    - user: discourse
    - group: discourse
    - mode: 440
    - require:
      - user: discourse
      - file: discourse_tar
