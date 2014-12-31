{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Setup a Salt API REST server.
-#}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
{%- set api_version = '0.8.4' -%}
{%- set ssl = salt['pillar.get']('salt_api:ssl', False) %}

include:
  - git
  - local
  - nginx
  - pip
  - rsyslog
  - salt.master
{% if ssl %}
  - ssl
{% endif %}

salt_api:
  group:
    - present

{%- set external_auth = salt['pillar.get']('salt_api:external_auth', {}) %}
{%- for authen_system in external_auth %}
    {%- if authen_system == 'pam' %}
        {%- for user in external_auth[authen_system] %}
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
    - password: {{ salt['password.encrypt_shadow'](external_auth[authen_system][user]) }}
    - watch:
      - user: user_{{ user }}
        {%- endfor %}
    {%- endif %}
{%- endfor %}

/etc/salt/master.d/ui.conf:
  file:
    - absent
    - watch_in:
      - service: salt-master

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
    - watch_in:
      - service: salt-master

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
    - watch_in:
      - service: nginx

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
{%- if salt['pillar.get']('files_archive', False) %}
      - salt-api: {{ salt['pillar.get']('files_archive', False)|replace('file://', '')|replace('https://', 'http://') }}/mirror/salt/{{ api_path }}
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

{% if ssl %}
extend:
  nginx.conf:
    file:
      - context:
          ssl: {{ ssl }}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
