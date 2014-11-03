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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Salt Archive Server HTTP/HTTPS.
-#}

{%- set ssl = salt['pillar.get']('salt_archive:ssl', False) -%}

include:
  - bash
  - cron
  - local
  - nginx
  - pysc
  - rsync
  - salt.archive
  - ssh.server
{%- if ssl %}
  - ssl
{%- endif %}

/etc/cron.hourly/salt_archive:
  file:
    - absent

/etc/cron.d/salt-archive:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 500
    - source: salt://salt/archive/server/cron.jinja2
    - require:
      - user: salt_archive
      - pkg: rsync
      - file: bash
{%- if not pillar['salt_archive']['source'] is defined %}
      - file: /usr/local/bin/salt_archive_incoming.py
    {#-
     if pillar['salt_archive']['source'] is not defined, create an incoming
     directory.
    #}

/var/lib/salt_archive/incoming:
  file:
    - directory
    - user: root
    - group: salt_archive
    - mode: 775
    - require:
      - file: salt_archive

    {%- for type in ('pip', 'mirror') %}
/var/lib/salt_archive/incoming/{{ type }}:
  file:
    - directory
    - user: root
    - group: salt_archive
    - mode: 775
    - require:
      - user: salt_archive
      - file: /var/lib/salt_archive/incoming
    {%- endfor %}

    {%- for type in ('pip', 'mirror') %}
/var/lib/salt_archive/{{ type }}:
  file:
    - directory
    - user: root
    - group: salt_archive
    - mode: 775
    - require:
      - file: salt_archive
    {%- endfor %}

/usr/local/bin/salt_archive_incoming.py:
  pkg:
    - installed
    - name: lsof
  file:
    - managed
    - user: root
    - group: root
    - source: salt://salt/archive/server/incoming.py
    - mode: 550
    - require:
      - pkg: /usr/local/bin/salt_archive_incoming.py
      - pkg: rsync
      - file: /usr/local
      - file: /var/lib/salt_archive/incoming/pip
      - file: /var/lib/salt_archive/incoming/mirror
      - file: /var/lib/salt_archive/pip
      - file: /var/lib/salt_archive/mirror
      - module: pysc
{%- else %}
    {#-
     if pillar['salt_archive']['source'] is defined, can't have an incoming
     directory.
    #}

/var/lib/salt_archive/incoming:
  file:
    - absent

/usr/local/bin/salt_archive_sync.sh:
  file:
    - managed
    - user: root
    - group: root
    - source: salt://salt/archive/server/salt_archive_sync.jinja2
    - template: jinja
    - mode: 550
    - require:
      - file: /usr/local
      - file: bash
    - require_in:
      - file: /etc/cron.d/salt-archive

archive_rsync:
  cmd:
    - wait
    - name: /usr/local/bin/salt_archive_sync.sh -v
    - user: root
    - require:
      - pkg: rsync
      - file: /usr/local/bin/salt_archive_sync.sh
    - watch:
      - file: salt_archive
{%- endif %}

/etc/nginx/conf.d/salt_archive.conf:
  file:
    - managed
    - template: jinja
    - source: salt://salt/archive/server/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - file: salt_archive
      - pkg: nginx
    - watch_in:
      - service: nginx

salt-archive-clamav:
  file:
    - name: /usr/local/bin/salt_archive_clamav.sh
{%- if salt['pillar.get']('salt_archive:source', False) %}
    - absent
{%- else %}
    - managed
    - source: salt://salt/archive/server/clamav.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - require:
      - pkg: salt-archive-clamav
  cmd:
    - run
    - name: /usr/local/bin/salt_archive_clamav.sh
    - require:
      - file: salt-archive-clamav
      - user: salt_archive
  pkg:
    - installed
    - name: wget
    - require:
      - cmd: apt_sources
{%- endif -%}

{%- for key in salt['pillar.get']('salt_archive:keys', []) %}
salt_archive_{{ key }}:
  ssh_auth:
    - present
    - name: {{ key }}
    - user: salt_archive
    - enc: {{ pillar['salt_archive']['keys'][key] }}
    - require:
      - file: salt_archive
      - service: openssh-server
{%- endfor %}

extend:
  web:
    user:
      - groups:
        - salt_archive
      - require:
        - user: salt_archive
  nginx:
    service:
      - watch:
        - user: salt_archive
{%- if ssl %}
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{%- endif -%}
