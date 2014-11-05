{#-
Copyright (c) 2013, Hung Nguyen Viet
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

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
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
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/terracotta-{{ version }}.tar.gz
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
