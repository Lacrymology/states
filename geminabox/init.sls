{#- Usage of this is governed by a license that can be found in doc/license.rst
Install geminabox (https://github.com/geminabox/geminabox)
-#}

{%- set ssl = salt['pillar.get']('geminabox:ssl', False) %}
include:
  - local
  - nginx
  - uwsgi.ruby
  - ruby
  - web

/usr/local/geminabox:
  file:
    - directory
    - user: geminabox
    - group: geminabox
    - mode: 750
    - require:
      - user: geminabox
      - file: /usr/local

geminabox:
  user:
    - present
    - groups:
      - www-data
    - require:
      - user: web
  gem:
    - installed
    - name: bundler
    - version: 1.7.3
    - user: root
    - require:
      - pkg: ruby
  file:
    - managed
    - name: /usr/local/geminabox/Gemfile
    - source: salt://geminabox/Gemfile
    - user: root
    - group: geminabox
    - mode: 440
    - require:
      - file: /usr/local/geminabox
  cmd:
    - wait
    - name: bundle install --deployment
    - user: geminabox
    - cwd: /usr/local/geminabox
    - require:
      - gem: geminabox
    - watch:
      - file: /usr/local/geminabox/Gemfile.lock

/usr/local/geminabox/Gemfile.lock:
  file:
    - managed
    - source: salt://geminabox/Gemfile.lock
    - user: root
    - group: geminabox
    - mode: 440
    - require:
      - file: /usr/local/geminabox/Gemfile

/var/lib/geminabox-data:
  file:
    - directory
    - user: geminabox
    - group: geminabox
    - mode: 750
    - require:
      - user: geminabox

{%- set username = salt["pillar.get"]("geminabox:username", False) %}
{%- set password = salt["pillar.get"]("geminabox:password", False) %}
{%- set proxy_mode = salt["pillar.get"]("geminabox:proxy_mode", False) %}
/usr/local/geminabox/config.ru:
  file:
    - managed
    - source: salt://geminabox/config.ru.jinja2
    - template: jinja
    - user: root
    - group: geminabox
    - mode: 440
    - context:
        proxy_mode: {{ proxy_mode }}
        username: {{ username }}
        password: {{ password }}
    - require:
      - file: /usr/local/geminabox/Gemfile
      - file: /var/lib/geminabox-data

geminabox-uwsgi:
  file:
    - managed
    - name: /etc/uwsgi/geminabox.yml
    - source: salt://geminabox/uwsgi.jinja2
    - template: jinja
    - user: root
    - group: geminabox
    - mode: 440
    - context:
      appname: geminabox
      chdir: /usr/local/geminabox
      rack: config.ru
      uid: geminabox
      gid: geminabox
    - require:
      - cmd: geminabox
      - service: uwsgi
      - file: /usr/local/geminabox/config.ru
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/geminabox.yml
    - require:
      - file: geminabox
    - watch:
      - cmd: geminabox
      - file: /usr/local/geminabox/config.ru

/etc/nginx/conf.d/geminabox.conf:
  file:
    - managed
    - source: salt://geminabox/nginx.jinja2
    - template: jinja
    - group: www-data
    - user: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - user: web
      - file: geminabox-uwsgi
{%- if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{%- endif %}
    - watch_in:
      - service: nginx
