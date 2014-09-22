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

Install uWSGI Web app server.
This build come with only Python support.

To turn on Ruby support, include uwsgi.ruby instead of this file.
For PHP include uwsgi.php instead.
You can include both uwsgi.php and uwsgi.ruby.
-#}
include:
  - git
  - local
  - python.dev
  - rsyslog
  - salt.minion.deps
  - web
  - xml

{#- Upgrade uwsgi from 1.4 to 1.9.17.1 #}
{% set prefix = '/etc/uwsgi' %}
{#- salt does not support maxdepth, use this hack to get list of old ini files in /etc/uwsgi, not deeper #}
{%- for filename in salt['file.find'](prefix, name='*.ini', type='f') %}
    {%- if (filename.split('/')|length) == 4 %}
uwsgi_upgrade_remove_old_app_config_{{ filename }}:
  file:
    - absent
    - name: {{ filename }}
    - require_in:
      - file: uwsgi_upgrade_remove_old_version
    {%- endif %}
{%- endfor %}

uwsgi_upgrade_remove_old_version:
  file:
    - absent
    - name: /usr/local/uwsgi

{%- set version = '1.9.17.1' -%}
{%- set extracted_dir = '/usr/local/uwsgi-{0}'.format(version) %}

/etc/init/uwsgi.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
      extracted_dir: {{ extracted_dir }}
    - source: salt://uwsgi/upstart.jinja2

/etc/uwsgi.yml:
  file:
    - managed
    - template: jinja
    - source: salt://uwsgi/config.jinja2
    - mode: 440

uwsgi_patch_carbon_name_order:
  pkg:
    - installed
    - name: patch
{#- https://github.com/unbit/uwsgi/issues/534 #}
  file:
    - patch
    - name: {{ extracted_dir }}/plugins/carbon/carbon.c
    - source: salt://uwsgi/carbon.patch
    - hash: md5=1f96187b79550be801a9ab1397cb66ca
    - require:
      - archive: uwsgi_build
      - pkg: uwsgi_patch_carbon_name_order

uwsgi_build:
  archive:
    - extracted
    - name: /usr/local
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/uwsgi-{{ version }}.tar.gz
{%- else %}
    - source: http://projects.unbit.it/downloads/uwsgi-{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=501f29ad4538193c0ef585b4cef46bcf
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ extracted_dir }}
    - require:
      - file: /usr/local
  file:
    - managed
    - name: {{ extracted_dir }}/buildconf/custom.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://uwsgi/buildconf.jinja2
    - require:
      - archive: uwsgi_build
  cmd:
    - wait
    - name: python uwsgiconfig.py --clean; python uwsgiconfig.py --build custom
    - cwd: {{ extracted_dir }}
    - stateful: false
    - watch:
      - pkg: xml-dev
      - archive: uwsgi_build
      - file: uwsgi_build
      - pkg: python-dev
      - file: uwsgi_patch_carbon_name_order

uwsgi_sockets:
  file:
    - directory
    - name: /var/lib/uwsgi
    - user: www-data
    - group: www-data
    - mode: 770
    - require:
      - user: web
      - cmd: uwsgi_build
      - archive: uwsgi_build
      - file: uwsgi_build

{#- does not use PID, no need to manage #}
uwsgi_emperor:
  cmd:
    - wait
    - name: strip {{ extracted_dir }}/uwsgi
    - stateful: false
    - watch:
      - archive: uwsgi_build
      - file: uwsgi_build
      - cmd: uwsgi_build
  service:
    - running
    - name: uwsgi
    - enable: True
    - order: 50
    - require:
      - file: uwsgi_emperor
      - file: uwsgi_sockets
      - service: rsyslog
      - pkg: salt_minion_deps
    - watch:
      - cmd: uwsgi_emperor
      - file: uwsgi_upgrade_remove_old_version
      - file: /etc/init/uwsgi.conf
      - file: /etc/uwsgi.yml
      - user: web
  file:
    - directory
    - name: /etc/uwsgi
    - user: www-data
    - group: www-data
    - mode: 550
    - require:
      - user: web

{% from 'rsyslog/upstart.sls' import manage_upstart_log with context %}
{{ manage_upstart_log('uwsgi') }}

{#- remove old uwsgi .ini config files #}
/etc/uwsgi.ini:
  file:
    - absent

/etc/uwsgi/apps-available:
  file:
    - absent

/etc/uwsgi/apps-enabled:
  file:
    - absent