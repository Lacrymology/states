{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
{%- set ssl = salt['pillar.get']('etherpad:ssl', False) %}
include:
  - apt
  - debian.package_build
  - nginx
  - nodejs
  - local
  - postgresql.server
  - python.dev
  - rsyslog
{%- if ssl %}
  - ssl
{%- endif %}
{#- Etherpad depends on libssl-dev #}
  - ssl.dev
  - web

{%- set version = "1.3.0" %}
{%- set web_root_dir = "/usr/local/etherpad-lite-" + version %}

etherpad-dependencies:
  pkg:
    - installed
    - pkgs:
      - curl
      - pkg-config
    - require:
      - pkg: package_build
      - pkg: ssl-dev
      - pkg: nodejs
      - pkg: python-dev
      - cmd: apt_sources

{%- set dbuser = salt['pillar.get']('etherpad:db:username', 'etherpad') %}
{%- set dbuserpass = salt['password.pillar']('etherpad:db:password', 10) %}
{%- set dbhost = salt['pillar.get']('etherpad:db:host', 'localhost') %}
{%- set dbname = salt['pillar.get']('etherpad:db:name', 'etherpad') %}

{{ web_root_dir }}:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - user: web
      - archive: etherpad
      - pkg: etherpad-dependencies
  cmd:
    - wait
    - name: chown -R root:www-data {{ web_root_dir }} && chmod -R u=rwX,g=rX,o= {{ web_root_dir }}
    - watch:
      - archive: etherpad
      - file: {{ web_root_dir }}

etherpad:
  postgres_user:
    - present
    - name: {{ dbuser }}
    - password: {{ dbuserpass }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ dbname }}
    - owner: {{ dbuser }}
    - runas: postgres
    - require:
      - postgres_user: etherpad
  archive:
    - extracted
    - name: /usr/local/
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - source: {{ files_archive }}/mirror/etherpad-lite-{{ version }}.tar.gz
{%- else %}
    - source: https://github.com/ether/etherpad-lite/archive/{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=baa4e7c8588cfcf5c2a4ef7768de5e89
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_root_dir }}
    - require:
      - file: /usr/local
  user:
    - present
    - groups:
      - www-data
    - shell: /usr/sbin/nologin
    - home: /home/etherpad
    - require:
      - user: web
  file:
    - managed
    - name: /etc/init/etherpad.conf
    - source: salt://etherpad/upstart.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        web_root_dir: {{ web_root_dir }}
        user: etherpad
    - require:
      - user: etherpad
  service:
    - running
    - order: 50
    - enable: True
    - require:
      - cmd: {{ web_root_dir }}
      - postgres_database: etherpad
    - watch:
      - user: etherpad
      - file: {{ web_root_dir }}/node_modules
      - file: {{ web_root_dir }}/src
      - file: {{ web_root_dir }}/var
      - file: {{ web_root_dir }}/src/package.json
      - file: {{ web_root_dir }}/src/static/custom
      - file: {{ web_root_dir }}/APIKEY.txt
      - file: {{ web_root_dir }}/settings.json
      - file: etherpad

{{ manage_upstart_log('etherpad') }}

{{ web_root_dir }}/node_modules:
  file:
    - directory
    - user: etherpad
    - group: root
    - mode: 700
    - require:
      - cmd: {{ web_root_dir }}

{{ web_root_dir }}/src:
  file:
    - directory
    - user: etherpad
    - group: root
    - mode: 700
    - require:
      - cmd: {{ web_root_dir }}

{{ web_root_dir }}/var:
  file:
    - directory
    - user: etherpad
    - group: root
    - mode: 700
    - require:
      - cmd: {{ web_root_dir }}

{{ web_root_dir }}/src/package.json:
  file:
    - managed
    - source: salt://etherpad/package.json
    - user: etherpad
    - group: root
    - mode: 400
    - require:
      - file: {{ web_root_dir }}/src

{{ web_root_dir }}/src/static/custom:
  file:
    - directory
    - user: etherpad
    - group: root
    - mode: 700
    - require:
      - cmd: {{ web_root_dir }}

{{ web_root_dir }}/APIKEY.txt:
  file:
    - managed
    - user: etherpad
    - group: root
    - mode: 400
    - source: salt://etherpad/api.jinja2
    - template: jinja
    - require:
      - cmd: {{ web_root_dir }}

{{ web_root_dir }}/settings.json:
  file:
    - managed
    - user: etherpad
    - group: root
    - mode: 400
    - source: salt://etherpad/settings.jinja2
    - template: jinja
    - context:
        dbuser: {{ dbuser }}
        dbuserpass: {{ dbuserpass }}
        dbname: {{ dbname }}
        dbhost: {{ dbhost }}
    - require:
      - cmd: {{ web_root_dir }}

/etc/nginx/conf.d/etherpad.conf:
  file:
    - managed
    - source: salt://etherpad/nginx.jinja2
    - template: jinja
    - user: root
    - group: www-data
    - mode: 440
    - context:
        appname: etherpad
    - require:
      - pkg: nginx
      - service: etherpad
    - watch_in:
      - service: nginx

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
