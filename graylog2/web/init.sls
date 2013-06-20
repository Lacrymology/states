{#
 Install a graylog2 web interface server

 Once this state is installed, you need to:

 - Create initial admin user.
   You can do it with your web browser by opening the Graylog2 Web interface
   of your deployed instance at URL:
   /users/first
 - Configure the Sentry DSN to receive alerts, in URL:
   /plugin_configuration/configure/transport/com.bitflippers.sentrytransport.transport.SentryTransport
 - Add a Sentry DSN to each of your users (can be the same) at:
   /users/
#}
include:
  - build
  - graylog2
  - gsyslog
  - mongodb
  - nginx
  - ruby
{% if pillar['graylog2']['ssl']|default(False) %}
  - ssl
{% endif %}
  - uwsgi.ruby
  - web

{% set version = '0.11.0' %}
{% set checksum = 'md5=35d20002dbc7f192a1adbcd9b53b2732' %}
{% set web_root_dir = '/usr/local/graylog2-web-interface-' + version %}

{% for previous_version in ('0.9.6p1',) %}
/usr/local/graylog2-web-interface-{{ previous_version }}:
  file:
    - absent
{% endfor %}

{% for filename in ('general', 'indexer', 'mongoid') %}
graylog2-web-{{ filename }}:
  file:
    - managed
    - name: {{ web_root_dir }}/config/{{ filename }}.yml
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://graylog2/web/{{ filename }}.jinja2
    - require:
      - user: web
{% endfor %}

{% for filename in ('config', 'email') %}
graylog2-web-{{ filename }}:
  file:
    - absent
    - name: {{ web_root_dir }}/config/{{ filename }}.yml
{% endfor %}

/etc/logrotate.d/graylog2-web:
  file:
    - absent

graylog2-web-upstart:
  file:
    - absent
    - name: /etc/init/graylog2-web.conf
  cmd:
    - wait
    - name: stop graylog2-web
    - watch:
      - file: graylog2-web-upstart

{{ web_root_dir }}/log:
  file:
    - symlink
    - force: True
    - target: /var/log/graylog2/
    - require:
      - archive: graylog2-web

graylog2-web:
  gem:
    - installed
    - name: bundler
    - version: 1.3.1
    - require:
      - pkg: ruby
      - pkg: build
    - watch:
      - archive: graylog2-web
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/graylog2-web-interface/{{ version }}.tar.gz
{%- else %}
    - source: http://download.graylog2.org/graylog2-web-interface/graylog2-web-interface-{{ version }}.tar.gz
{%- endif %}
    - source_hash: {{ checksum }}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_root_dir }}
  cmd:
    - wait
    - stateful: False
    - name: bundle install
    - cwd: {{ web_root_dir }}
    - require:
      - gem: graylog2-web
    - watch:
      - archive: graylog2-web
  file:
    - managed
    - name: /etc/uwsgi/graylog2.ini
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://graylog2/web/uwsgi.jinja2
    - context:
      version: {{ version }}
    - require:
      - user: web
      - file: {{ web_root_dir }}/log
      - service: uwsgi_emperor
      - service: mongodb
      - cmd: graylog2-web
      - service: gsyslog
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/graylog2.ini
    - require:
      - file: graylog2-web
    - watch:
      - archive: graylog2-web
{% for filename in ('general', 'indexer', 'mongoid') %}
      - file: graylog2-web-{{ filename }}
    - require:
      - file: /var/log/graylog2
{% endfor %}

change_graylog2_web_dir_permission:
  cmd:
    - wait
    - watch:
      - archive: graylog2-web
    - name: chown -R www-data:www-data {{ web_root_dir }}
    - require:
      - user: web

{% for command in ('streamalarms', 'subscriptions') %}
/etc/cron.hourly/graylog2-web-{{ command }}:
  file:
    - absent
{% endfor %}

/etc/nginx/conf.d/graylog2-web.conf:
  file:
    - managed
    - template: jinja
    - source: salt://graylog2/web/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
    - context:
      version: {{ version }}

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/graylog2-web.conf
{% if pillar['graylog2']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['graylog2']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['graylog2']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['graylog2']['ssl'] }}/ca.crt
{% endif %}
