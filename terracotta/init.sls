{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
  - hostname
  - java.7.jdk
  - local
  - rsyslog
{% set version = '3.7.0' %}

terracotta:
  archive:
    - name: /usr/local
    - extracted
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - source: {{ files_archive }}/mirror/terracotta-{{ version }}.tar.gz
{%- else %}
    - source: http://d2zwv9pap9ylyd.cloudfront.net/terracotta-3.7.0.tar.gz
{%- endif %}
    - source_hash: md5=ff54cad0febeb8a0c17154cac838c2cb
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/terracotta-{{ version }}
    - require:
      - file: /usr/local
  file:
    - managed
    - name: /etc/init/terracotta.conf
    - source: salt://terracotta/upstart.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        version: {{ version }}
  user:
    - present
  service:
    - running
    - order: 50
    - require:
      - pkg: jdk-7
      - archive: terracotta
      - file: /var/lib/terracotta/server-statistics
      - file: /var/log/terracotta/server-logs
      - file: /var/lib/terracotta/server-data
      - host: hostname
      - service: rsyslog
    - watch:
      - user: terracotta
      - file: terracotta
      - file: /etc/terracotta.conf
      - pkg: jre-7
      - file: jre-7

{{ manage_upstart_log('terracotta') }}

/etc/terracotta.conf:
  file:
    - managed
    - template: jinja
    - user: terracotta
    - group: terracotta
    - mode: 440
    - source: salt://terracotta/config.jinja2
    - require:
      - user: terracotta

/var/lib/terracotta/server-data:
  file:
    - directory
    - makedirs: True
    - user: terracotta
    - group: terracotta
    - mode: 750
    - require:
      - user: terracotta

/var/log/terracotta/server-logs:
  file:
    - directory
    - makedirs: True
    - user: terracotta
    - group: terracotta
    - mode: 750
    - require:
      - user: terracotta

/var/lib/terracotta/server-statistics:
  file:
    - directory
    - makedirs: True
    - user: terracotta
    - group: terracotta
    - mode: 750
    - require:
      - user: terracotta
