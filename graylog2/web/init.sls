{#-
Copyright (c) 2013, Bruno Clermont
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

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

Install a graylog2 web interface server.

Once this state is installed, you need to:

- Create initial admin user.
  You can do it with your web browser by opening the Graylog2 Web interface
  of your deployed instance at URL:
  /users/first
- Configure the Sentry DSN to receive alerts, in URL:
  /plugin_configuration/configure/transport/com.bitflippers.sentrytransport.transport.SentryTransport
- Add a Sentry DSN to each of your users (can be the same) at:
  /users/
-#}
include:
  - graylog2
  - graylog2.server
  - local
  - logrotate
  - mongodb
  - nginx
  - rsyslog
{% if salt['pillar.get']('graylog2:ssl', False) %}
  - ssl
{% endif %}
  - web

{% set version = '0.20.3' %}
{% set checksum = 'md5=7da99597ba0a3c81ca69882a9883ee9a' %}
{% set user = salt['pillar.get']('graylog2:web:user', 'graylog2-ui') %}
{% set web_root_dir = '/usr/local/graylog2-web-interface-' + version %}

{{ user }}:
  user:
    - present
    - name: {{ user }}
    - home: /var/run/{{ user }}
    - shell: /bin/false

{% for previous_version in ('0.9.6p1', '0.11.0') %}
/usr/local/graylog2-web-interface-{{ previous_version }}:
  file:
    - absent
{% endfor %}

graylog2-web_upstart:
  file:
    - managed
    - name: /etc/init/graylog2-web.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://graylog2/web/upstart.jinja2
    - context:
      web_root_dir: {{ web_root_dir }}
      user: {{ user }}

{{ web_root_dir }}/logs:
  file:
    - symlink
    - force: True
    - target: /var/log/graylog2/
    - require:
      - archive: graylog2-web
      - file: /var/log/graylog2

graylog2-web-logrotate:
  file:
    - managed
    - name: /etc/logrotate.d/graylog2-web
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://graylog2/web/logrotate.jinja2
    - require:
      - pkg: logrotate
        
graylog2-web:
  file:
    - managed
    - name: {{ web_root_dir }}/conf/graylog2-web-interface.conf
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 440
    - source: salt://graylog2/web/config.jinja2
    - require:
      - archive: graylog2-web
      - user: graylog2
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/graylog2-web-interface-{{ version }}.tar.gz
{%- else %}
    - source: http://download.graylog2.org/graylog2-web-interface/graylog2-web-interface-{{ version }}.tar.gz
{%- endif %}
    - source_hash: {{ checksum }}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_root_dir }}
    - require:
      - file: /usr/local
  service:
    - running
    - enable: True
    - watch:
      - file: graylog2-web_upstart
      - pkg: openjdk_jre_headless
      - archive: graylog2-web
      - user: graylog2
    - require:
      - file: /var/log/graylog2

change_graylog2_web_dir_permission:
  cmd:
    - wait
    - watch:
      - archive: graylog2-web
    - name: chown -R {{ user }}:{{ user }} {{ web_root_dir }}
    - require:
      - user: graylog2

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
{% if salt['pillar.get']('graylog2:ssl', False) %}
        - cmd: ssl_cert_and_key_for_{{ pillar['graylog2']['ssl'] }}
{% endif %}
