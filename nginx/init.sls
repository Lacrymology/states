{#-
Copyright (c) 2013, <BRUNO CLERMONT>
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

 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Install the Nginx web server
 -#}
include:
  - apt
  - web
  - rsyslog

{% set bad_configs = ('default', 'example_ssl') %}

{% for filename in bad_configs %}
/etc/nginx/conf.d/{{ filename }}.conf:
  file:
    - absent
    - require:
      - pkg: nginx
{% endfor %}

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
    - managed
    - name: /etc/init/nginx-logger-{{ log_type }}.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/upstart_logger.jinja2
    - context:
      type: {{ log_type }}
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - service: rsyslog
      - file: nginx-logger-{{ log_type }}
      - pkg: nginx
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
      - libssl-dev
      - zlib1g-dev
      - lsb-base
      - adduser
    - require:
      - cmd: apt_sources 

{%- set version = '1.4.1' %}
{%- set filename = 'nginx_{0}-1~{1}_{2}.deb'.format(version, grains['lsb_distrib_codename'], grains['debian_arch']) %}

nginx:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - nginx: {{ pillar['files_archive']|replace('file://', '') }}/mirror/{{ filename }}
{%- else %}
      - nginx: http://nginx.org/packages/ubuntu/pool/nginx/n/nginx/{{ filename }}
{%- endif %}
    - require:
      - user: web
      - pkg: nginx_dependencies
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
      - file: nginx
      - file: /etc/nginx/nginx.conf
{% for filename in bad_configs %}
      - file: /etc/nginx/conf.d/{{ filename }}.conf
{% endfor %}
      - pkg: nginx
    - require:
{% for log_type in logger_types %}
      - service: nginx-logger-{{ log_type }}
{% endfor %}

/etc/apt/sources.list.d/nginx.org-packages_ubuntu-precise.list:
  file:
    - absent
