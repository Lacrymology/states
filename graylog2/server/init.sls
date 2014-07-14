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

Install a Graylog2 logging server backend.
-#}
{%- from 'macros.jinja2' import manage_pid with context %}
include:
  - apt
  - bash
  - mongodb
  - java.7
  - graylog2
  - local
  - rsyslog

{#- TODO: set Email output plugin settings straight into MongoDB from salt #}
{%- set version = '0.20.3' %}
{%- set checksum = 'md5=41d26cc5d65d275038b972cce1a7c2e6' %}
{%- set server_root_dir = '/usr/local/graylog2-server-' + version %}
{%- set user = salt['pillar.get']('graylog2:server:user', 'graylog2') %}
{%- set mongodb_suffix = '0-20' %}

{% for previous_version in ('0.11.0', ) %}
/usr/local/graylog2-server-{{ previous_version }}:
  file:
    - absent
{% endfor %}

{# remove old mongodb db: graylog2 #}
graylog2-old-mongodb:
  mongodb_database:
    - absent
    - name: graylog2
    - host: 127.0.0.1
    - port: 27017
    - require:
      - pkg: mongodb
      - pkg: graylog2-old-mongodb
  pkg:
    - name: python-pymongo
    - installed

graylog2-server_upstart:
  file:
    - managed
    - name: /etc/init/graylog2-server.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://graylog2/server/upstart.jinja2
    - context:
      version: {{ version }}
      user: {{ user }}

/var/log/graylog2/server.log:
  file:
    - absent

/etc/graylog2:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - require:
      - user: {{ user }}

{# For cluster using, all node's data should be explicit: http,master,data,port and/or name #}
/etc/graylog2/elasticsearch.yml:
  file:
    - managed
    - source: salt://elasticsearch/config.jinja2
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 440
    - context:
      master: 'false'
      data: 'false'
      origin_state: graylog2.server
    - require:
      - file: /etc/graylog2

{#
We have to create this file before graylog2-server service start, because
graylog2 user may not have the required privilege to create file in /etc folder
#}
/etc/graylog2/server-node-id:
  file:
    - managed
    - user: {{ user }}
    - group: {{ user }}
    - mode: 644
    - require:
      - archive: graylog2-server
      - file: /etc/graylog2


graylog2-server:
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/graylog2-server-{{ version }}.tar.gz
{%- else %}
    - source: http://download.graylog2.org/graylog2-server/graylog2-server-{{ version }}.tar.gz
{%- endif %}
    - source_hash: {{ checksum }}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ server_root_dir }}
    - require:
      - file: /usr/local
  file:
    - managed
    - name: /etc/graylog2.conf
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 440
    - source: salt://graylog2/server/config.jinja2
    - context:
      version: {{ version }}
      mongodb_suffix: {{ mongodb_suffix }}
    - require:
      - user: {{ user }}
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - file: graylog2-server_upstart
      - pkg: openjdk_jre_headless
      - file: graylog2-server
      - file: /etc/graylog2/elasticsearch.yml
      - archive: graylog2-server
      - user: {{ user }}
      - file: /etc/graylog2/server-node-id
    - require:
      - file: /var/log/graylog2
      - file: /var/log/graylog2/server.log
      - service: mongodb
      - file: {{ server_root_dir }}
      - file: /var/run/graylog2

{%- call manage_pid('/var/run/graylog2/graylog2.pid', 'graylog2', 'syslog', 'graylog2-server') %}
- user: {{ user }}
- file: /var/run/graylog2
- pkg: rsyslog
{%- endcall %}

graylog2_rsyslog_config:
  file:
    - managed
    - mode: 440
    - source: salt://rsyslog/template.jinja2
    - name: /etc/rsyslog.d/graylog2-server.conf
    - template: jinja
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog
    - context:
      file_path: /var/log/graylog2/server.fifo
      tag_name: graylog2-server
      severity: info
      facility: local7

{{ server_root_dir }}:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - mode: 750
    - recurse:
      - user
      - group
    - require:
      - archive: graylog2-server
      - user: {{ user }}

{# Auto add General Syslog UDP input #}
import_general_syslog_udp_input graylog2-{{ mongodb_suffix }}:
  cmd:
    - script
    - source: salt://graylog2/server/import_general_syslog_udp_input.sh
    - require:
      - service: graylog2-server
      - pkg: bash
