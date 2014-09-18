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

Install the Nginx web server.
-#}
include:
  - apt
  - rsyslog
  - ssl.dev
  - web

{% set bad_configs = ('default', 'example_ssl') %}

{% for filename in bad_configs %}
/etc/nginx/conf.d/{{ filename }}.conf:
  file:
    - absent
    - require:
      - pkg: nginx
{% endfor %}

/etc/nginx/mime.types:
  file:
    - absent
    - require:
      - pkg: nginx

/etc/nginx/nginx.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/config.jinja2
    - require:
      - pkg: nginx
      - file: /etc/nginx/mime.types

nginx-old-init:
  file:
    - rename
    - name: /usr/share/nginx/init.d
    - source: /etc/init.d/nginx
    - require:
      - pkg: nginx
  cmd:
    - wait
    - name: dpkg-divert --divert /usr/share/nginx/init.d --add /etc/init.d/nginx
    - require:
      - module: nginx-old-init
    - watch:
      - file: nginx-old-init
  module:
    - wait
    - name: cmd.run
    - cmd: kill `cat /var/run/nginx.pid`
    - watch:
      - file: nginx-old-init

nginx-old-init-disable:
  cmd:
    - wait
    - name: update-rc.d -f nginx remove
    - require:
      - module: nginx-old-init
    - watch:
      - file: nginx-old-init

{% set logger_types = ('access', 'error') %}

{% for log_type in logger_types %}
/var/log/nginx/{{ log_type }}.log:
  file:
    - absent
    - require:
      - service: nginx

nginx-logger-{{ log_type }}:
  file:
    - absent
    - name: /etc/init/nginx-logger-{{ log_type }}.conf
    - require:
      - service: nginx-logger-{{ log_type }}
  service:
    - dead
{% endfor %}

/etc/logrotate.d/nginx:
  file:
    - absent
    - require:
      - pkg: nginx

nginx_dependencies:
  pkg:
    - installed
    - pkgs:
      - libpcre3-dev
      - zlib1g-dev
      - lsb-base
      - adduser
    - require:
      - pkg: ssl-dev
      - cmd: apt_sources

{%- set version = '1.7.4' %}
{%- set sub_version = '{0}-1~{1}'.format(version, grains['lsb_distrib_codename']) %}
{%- set filename = 'nginx_{0}_{1}.deb'.format(sub_version, grains['debian_arch']) %}

{#- PID file owned by root, no need to manage #}
nginx:
  file:
    - managed
    - name: /etc/init/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/upstart.jinja2
    - require:
      - pkg: nginx
      - file: nginx-old-init
      - module: nginx-old-init
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - user: web
      - file: nginx
      - file: /etc/nginx/nginx.conf
{%- for filename in bad_configs %}
      - file: /etc/nginx/conf.d/{{ filename }}.conf
{%- endfor %}
      - pkg: nginx
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - nginx: {{ pillar['files_archive']|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ filename }}
{%- else %}
      - nginx: http://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx/{{ filename }}
{%- endif %}
    - require:
      - user: web
      - pkg: nginx_dependencies
{%- for log_type in logger_types %}
      - file: nginx-logger-{{ log_type }}
{%- endfor %}

{%- if salt['pkg.version']('nginx') not in ('', sub_version) %}
nginx_old_version:
  pkg:
    - removed
    - name: nginx
    - require_in:
      - pkg: nginx
{%- endif %}

/etc/apt/sources.list.d/nginx.org-packages_ubuntu-precise.list:
  file:
    - absent

{#- This robots.txt file is used to deny all search engine, only affect if
    specific app uses it.  #}
/var/www/robots.txt:
  file:
    - managed
    - user: root
    - group: root
    - mode: 644
    - contents: |
        User-agent: *
        Disallow: /
    - require:
      - pkg: nginx
      - user: web
      - file: /var/www
    - require_in:
      - service: nginx

nginx_verify_version:
  cmd:
    - wait
    - name: nginx -v 2>&1 | grep -q '{{ version }}'
    - watch:
      - service: nginx

{% from 'rsyslog/upstart.sls' import manage_upstart_log with context %}
{{ manage_upstart_log('nginx') }}
