{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- from 'macros.jinja2' import manage_pid with context -%}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
{%- from "upstart/absent.sls" import upstart_absent with context %}
include:
  - python
  - apt
  - mongodb
  - mongodb.pymongo
  - java.7
  - graylog2
  - local
  - rsyslog
  - pysc
  - sudo
  - requests
{#-
  graylog2.server require elasticsearch, install it when testing to
  make the inputs importing work.  In production environment,
  elasticsearch doesn't need to be install in same machine as
  graylog2.server
#}
{%- if salt['pillar.get']("__test__", False) %}
  - elasticsearch
{%- endif %}

{%- set version = '0.20.6' %}
{%- set checksum = 'md5=a9105a4fb5c950b3760df02dface6465' %}
{%- set server_root_dir = '/usr/local/graylog2-server-' + version %}
{%- set user = salt['pillar.get']('graylog2:server:user', 'graylog2') %}
{%- set mongodb_suffix = '0-20' %}
{%- set elasticsearch_prefix = '0-20' %}

{% for previous_version in ('0.11.0', '0.20.3') %}
/usr/local/graylog2-server-{{ previous_version }}:
  file:
    - absent
{% endfor %}

{{ upstart_absent('graylog2-server-prep') }}

/var/log/graylog2/server.log:
  file:
    - absent

/etc/graylog2:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - mode: 550
    - require:
      - user: graylog2

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
      - user: graylog2

/var/lib/graylog2:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - mode: 750
    - require:
      - archive: graylog2-server
      - user: graylog2

graylog2.conf:
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
        elasticsearch_prefix: {{ elasticsearch_prefix }}
    - require:
      - user: graylog2

graylog2-server:
  archive:
    - extracted
    - name: /usr/local/
{%- if salt['pillar.get']('files_archive', False) %}
    - source: {{ salt['pillar.get']('files_archive', False) }}/mirror/graylog2-server-{{ version }}.tar.gz
{%- else %}
    - source: http://packages.graylog2.org/releases/graylog2-server/graylog2-server-{{ version }}.tgz
{%- endif %}
    - source_hash: {{ checksum }}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ server_root_dir }}
    - require:
      - file: /usr/local
  file:
    - managed
    - name: /etc/init/graylog2-server.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - source: salt://graylog2/server/upstart.jinja2
    - context:
        version: {{ version }}
        user: {{ user }}
    - require:
      - file: graylog2-server-prep
      - pkg: sudo
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - file: graylog2-server
      - pkg: jre-7
      - file: jre-7
      - file: graylog2.conf
      - file: /etc/graylog2/elasticsearch.yml
      - archive: graylog2-server
      - user: graylog2
      - file: /var/lib/graylog2
    - require:
      - file: /var/log/graylog2
      - file: /var/log/graylog2/server.log
      - service: mongodb
      - file: {{ server_root_dir }}
      - file: /var/run/graylog2
{%- if salt['pillar.get']("__test__", False) %}
      - process: elasticsearch
{%- endif %}
{%- set parsed_url = salt['common.urlparse'](salt['pillar.get']('graylog2:rest_listen_uri', 'http://127.0.0.1:12900')) -%}
{%- set hostname = parsed_url.hostname %}
{%- set port = parsed_url.port %}
  process:
    - wait_socket
    - address: {{ hostname }}
    - port: {{ port }}
    - require:
      - service: graylog2-server

{{ manage_upstart_log('graylog2-server') }}

{%- call manage_pid('/var/run/graylog2/graylog2.pid', user, 'syslog', 'graylog2-server') %}
- user: graylog2
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
      - user: graylog2

import_graylog2_gelf:
  graylog:
    - gelf_input
    {#- The following parameters have their default values and are unnecessary #}
    - title: gelf
    - stype: udp
    - port: 12201
    - creator: {{ salt['pillar.get']('graylog2:admin_username', 'admin') }}
    - bind_address: 0.0.0.0
    - buffer_size: 1048576
    - require:
      - process: graylog2-server
      - module: requests

import_graylog2_syslog:
  graylog:
    - syslog_input
    {#- The following parameters have their default values and are unnecessary #}
    - title: syslog
    - stype: udp
    - port: 1514
    - creator: {{ salt['pillar.get']('graylog2:admin_username', 'admin') }}
    - bind_address: 0.0.0.0
    - buffer_size: 1048576
    - allow_override_date: true
    - store_full_message: false
    - force_rdns: false
    - require:
      - process: graylog2-server
      - module: requests

/var/log/graylog2:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755  {# syslog user needs to read the fifo in this folder #}
    - makedirs: True
    - require:
      - user: graylog2
