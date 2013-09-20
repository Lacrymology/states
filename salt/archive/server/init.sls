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

Author: Bruno Clermont patate@fastmail.cn
Maintainer: Bruno Clermont patate@fastmail.cn

Salt Archive Server HTTP/HTTPS
==============================

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.
salt_archive:
  web:
    hostnames:
      - archive.example.com

salt_archive:web:hostnames: list of hostname of the web archive

Optional Pillar
---------------

salt_archive:
  source: rsync://archive.robotinfra.com/archive/
  delete: True
  web:
    ssl: mykeyname
    ssl_redirect: True
  keys:
    00daedbeef: ssh-dss

salt_archive:source: rsync server used as the source for archived files.
salt_archive:web:ssl: SSL key to use to secure this server archive
salt_archive:web:ssl_redirect: if True, redirect all HTTP traffic to HTTPs.
salt_archive:keys: dict of keys allowed to log in user

This state also need the following pillar for rsync state:

rsync:
  uid: salt_archive
  gid: salt_archive
  'use chroot': yes
  shares:
    archive:
      path: /var/lib/salt_archive
      'read only': true
      'dont compress': true
      exclude: .* incoming

You can change the name 'archive' by something else. but you need to change your
files_archive pillar value accordingly.
-#}

{%- set ssl = pillar['salt_archive']['web']['ssl']|default(False) -%}

include:
  - cron
  - local
  - nginx
  - rsync
  - salt.archive
  - ssh.server
{%- if ssl %}
  - ssl
{%- endif %}

/etc/cron.hourly/salt_archive:
  file:
    - absent

{%- if not salt['pillar.get']('salt_archive:source', False) %}
/etc/cron.d/salt-archive:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://salt/archive/server/cron.jinja2
    - require:
      - user: salt_archive
      - file: /usr/local/bin/salt_archive_incoming.py
    {#-
     if pillar['salt_archive']['source'] is not defined, create an incoming
     directory.
    #}

salt_archive_incoming:
  file:
    - directory
    - name: /var/lib/salt_archive/incoming
    - user: salt_archive
    - group: salt_archive
    - mode: 550
    - require:
      - user: salt_archive

    {%- for type in ('pip', 'mirror') %}
/var/lib/salt_archive/incoming/{{ type }}:
  file:
    - directory
    - user: salt_archive
    - group: salt_archive
    - mode: 770
    - require:
      - user: salt_archive
      - file: salt_archive_incoming
    {%- endfor %}

/usr/local/bin/salt_archive_incoming.py:
  file:
    - managed
    - user: root
    - group: root
    - source: salt://salt/archive/server/incoming.py
    - mode: 550
    - require:
      - file: /usr/local
{%- else %}
    {#-
     if pillar['salt_archive']['source'] is defined, can't have an incoming
     directory.
    #}
/etc/cron.d/salt-archive:
  file:
    - absent

/var/lib/salt_archive/incoming:
  file:
    - absent

archive_rsync:
  cmd:
    - run
    - name: rsync -av {% if salt['pillar.get']('salt_archive:delete', False) %} --delete{% endif %} --exclude ".*" {{ pillar['salt_archive']['source'] }} /var/lib/salt_archive/
    - require:
      - pkg: rsync
      - user: salt_archive
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

{% for key in salt['pillar.get']('salt_archive:keys', []) -%}
salt_archive_{{ key }}:
  ssh_auth:
    - present
    - name: {{ key }}
    - user: salt_archive
    - enc: {{ pillar['salt_archive']['keys'][key] }}
    - require:
      - user: salt_archive
      - service: openssh-server
{% endfor -%}

extend:
  cron:
    service:
      - watch:
        - file: /etc/cron.d/salt-archive
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/salt_archive.conf
{%- if ssl %}
        - cmd: /etc/ssl/{{ ssl }}/chained_ca.crt
        - module: /etc/ssl/{{ ssl }}/server.pem
        - file: /etc/ssl/{{ ssl }}/ca.crt
{%- endif -%}
