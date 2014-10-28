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

Setup a Salt API REST server.
-#}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
{%- set api_version = '0.8.4' -%}
include:
  - git
  - local
  - nginx
  - pip
  - rsyslog
  - salt.master
{% if salt['pillar.get']('salt_master:ssl', False) %}
  - ssl
{% endif %}

salt_api:
  group:
    - present

{% for user in pillar['salt_master']['external_auth']['pam'] %}
user_{{ user }}:
  user:
    - present
    - name: {{ user }}
    - groups:
      - salt_api
    - home: /home/{{ user }}
    - shell: /bin/false
    - require:
      - group: salt_api
  module:
    - wait
    - name: shadow.set_password
    - m_name: {{ user }}
    - password: {{ salt['password.encrypt_shadow'](pillar['salt_master']['external_auth']['pam'][user]) }}
    - watch:
      - user: user_{{ user }}
{% endfor %}

/etc/salt/master.d/ui.conf:
  file:
    - absent

/etc/salt/master.d/api.conf:
  file:
    - managed
    - template: jinja
    - source: salt://salt/api/config.jinja2
    - user: root
    - group: root
    - mode: 400
    - require:
      - pkg: salt-master

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/salt-api-requirements.txt:
  file:
    - absent

salt-api-requirements:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/salt.api
    - source: salt://salt/api/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/pip/salt.api
    - watch:
      - file: salt-api-requirements

salt-ui:
  file:
    - absent
    - name: /usr/local/salt-ui

/etc/nginx/conf.d/salt-api.conf:
  file:
    - managed
    - template: jinja
    - source: salt://salt/api/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx

{#- PID file owned by root, no need to manage #}
{%- from "macros.jinja2" import salt_version with context %}
{%- set api_path = salt_version() ~ '/pool/main/s/salt-api/salt-api_' + api_version + '_all.deb' %}
salt-api:
  file:
    - managed
    - name: /etc/init/salt-api.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/api/upstart.jinja2
    - require:
      - pkg: salt-api
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - service: rsyslog
    - watch:
      - file: salt-api
      - module: salt-api-requirements
      - file: /etc/salt/master.d/api.conf
      - pkg: salt-api
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - salt-api: {{ pillar['files_archive']|replace('file://', '')|replace('https://', 'http://') }}/mirror/salt/{{ api_path }}
{%- else %}
      - salt-api: http://archive.robotinfra.com/mirror/salt/{{ api_path }}
{%- endif %}
    - require:
      - pkg: salt-master
      - module: salt-api-requirements

{{ manage_upstart_log('salt-api') }}

{%- if salt['pkg.version']('salt-api') not in ('', api_version) %}
salt_api_old_version:
  pkg:
    - purged
    - name: salt-api
    - require_in:
      - pkg: salt-api
{%- endif %}

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/salt-api.conf
{% if salt['pillar.get']('salt_master:ssl', False) %}
        - cmd: ssl_cert_and_key_for_{{ pillar['salt_master']['ssl'] }}
{% endif %}
  salt-master:
    service:
      - watch:
        - file: /etc/salt/master.d/api.conf
        - file: /etc/salt/master.d/ui.conf
