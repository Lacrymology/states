{#- Usage of this is governed by a license that can be found in doc/license.rst #}
{%- from "countly/map.jinja2" import countly with context %}
{%- set hostnames = salt["pillar.get"]("countly:hostnames") %}
{%- set ssl = salt['pillar.get']('countly:ssl', False) %}
{%- set ssl_redirect = salt['pillar.get']('countly:ssl_redirect', False) %}

include:
  - apt
  - build
  - hostname
  - local
  - mongodb
  - nginx
  - nodejs
  - web
{%- if ssl %}
  - ssl
{%- endif %}

/usr/local/countly:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 550
    - require:
      - file: /usr/local
      - user: web

countly_install_dir:
  file:
    - directory
    - name: {{ countly.install_dir }}
    - user: root
    - group: www-data
    - mode: 550
    - require:
      - file: /usr/local/countly
      - user: web

countly_cleanup_old_files:
  cmd:
    - wait
    - name: find /usr/local/countly -maxdepth 1 -mindepth 1 -type d ! -name '{{ countly.version }}' -exec rm -r '{}' \;
    - require:
      - service: countly_api
      - service: countly_dashboard
    - watch:
      - file: countly_install_dir

/var/lib/countly:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 750
    - require:
      - user: web

countly-node_modules:
  file:
    - directory
    - name: {{ countly.install_dir }}/countly/node_modules
    - user: www-data
    - group: www-data
    - mode: 750
    - require:
      - archive: countly

countly-grunt:
  cmd:
    - wait
    - name: npm install grunt-cli --verbose
    - user: www-data
    - group: www-data
    - env:
        - HOME: /var/lib/countly
    - cwd: {{ countly.install_dir }}/countly
    - require:
      - pkg: build
      - pkg: nodejs
      - user: web
      - file: /var/lib/countly
      - file: countly-node_modules
    - watch:
      - archive: countly

countly:
  pkg:
    - installed
    - pkgs:
      - imagemagick
    - require:
      - cmd: apt_sources
  archive:
    - extracted
    - name: {{ countly.install_dir }}
    - source: {{ countly.source }}
    - source_hash: {{ countly.source_hash }}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ countly.install_dir }}/countly
    - require:
      - file: countly_install_dir
  cmd:
    - wait
    - name: npm install --verbose
    - user: www-data
    - group: www-data
    - env:
        - HOME: /var/lib/countly
    - cwd: {{ countly.install_dir }}/countly
    - require:
      - cmd: countly-grunt
    - watch:
      - archive: countly

countly_javascripts_min:
  file:
    - directory
    - name: {{ countly.install_dir }}/countly/frontend/express/public/javascripts/min
    - user: www-data
    - group: www-data
    - mode: 750
    - require:
      - archive: countly
      - user: web

countly_stylesheets_min:
  file:
    - directory
    - name: {{ countly.install_dir }}/countly/frontend/express/public/stylesheets
    - user: www-data
    - group: www-data
    - mode: 750
    - require:
      - archive: countly
      - user: web

countly_localization_min:
  file:
    - directory
    - name: {{ countly.install_dir }}/countly/frontend/express/public/localization/min
    - user: www-data
    - group: www-data
    - mode: 750
    - require:
      - archive: countly
      - user: web

countly_plugins:
  file:
    - managed
    - name: {{ countly.install_dir }}/countly/plugins/plugins.json
    - template: jinja
    - source: salt://countly/plugins.jinja2
    - user: root
    - group: www-data
    - mode: 440
    - require:
      - cmd: countly
      - user: web
  cmd:
    - wait
    - name: nodejs install_plugins
    - cwd: {{ countly.install_dir }}/countly/bin/scripts
    - user: www-data
    - group: www-data
    - env:
        - PATH: {{ countly.install_dir }}/countly/node_modules/.bin:{{ salt["environ.get"]("PATH") }}
    - require:
      - pkg: nodejs
      - file: countly_javascripts_min
      - file: countly_stylesheets_min
      - file: countly_localization_min
      - file: countly_config
      - file: countly_api_config
      - file: countly_dashboard_config
    - watch:
      - file: countly_plugins
      - archive: countly

countly_compile:
  cmd:
    - wait
    - name: {{ countly.install_dir }}/countly/node_modules/.bin/grunt dist-all
    - cwd: {{ countly.install_dir }}/countly/bin
    - user: www-data
    - group: www-data
    - require:
      - cmd: countly_plugins
    - watch:
      - archive: countly

countly_config:
  file:
    - managed
    - name: {{ countly.install_dir }}/countly/frontend/express/public/javascripts/countly/countly.config.js
    - template: jinja
    - source: salt://countly/config.jinja2
    - user: root
    - group: www-data
    - mode: 440
    - require:
      - archive: countly
      - user: web

countly_api_config:
  file:
    - managed
    - name: {{ countly.install_dir }}/countly/api/config.js
    - template: jinja
    - source: salt://countly/api.jinja2
    - user: root
    - group: www-data
    - mode: 440
    - context:
        hostnames: {{ hostnames }}
    - require:
      - archive: countly
      - user: web

countly_api:
  file:
    - managed
    - name: /etc/init/countly_api.conf
    - source: salt://countly/api_upstart.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        chdir: {{ countly.install_dir }}/countly
    - require:
      - file: countly_api_config
      - cmd: countly_compile
  service:
    - running
    - require:
      - service: mongodb
    - watch:
      - archive: countly
      - file: countly_api
      - file: countly_api_config

countly_dashboard_config:
  file:
    - managed
    - name: {{ countly.install_dir }}/countly/frontend/express/config.js
    - template: jinja
    - source: salt://countly/frontend.jinja2
    - user: root
    - group: www-data
    - mode: 440
    - require:
      - archive: countly
      - user: web

countly_dashboard:
  file:
    - managed
    - name: /etc/init/countly_dashboard.conf
    - source: salt://countly/dashboard_upstart.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        chdir: {{ countly.install_dir }}/countly
    - require:
      - file: countly_dashboard_config
      - cmd: countly_compile
  service:
    - running
    - require:
      - service: mongodb
    - watch:
      - archive: countly
      - file: countly_dashboard
      - file: countly_dashboard_config

/etc/nginx/conf.d/countly.conf:
  file:
    - managed
    - source: salt://countly/nginx.jinja2
    - template: jinja
    - user: root
    - group: www-data
    - mode: 440
    - context:
        appname: countly
    - require:
      - pkg: nginx
      - user: web
      - service: countly_api
      - service: countly_dashboard
{%- if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{%- endif %}
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
