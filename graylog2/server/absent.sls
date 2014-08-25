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

Uninstall a Graylog2 logging server backend.
-#}

{%- set version = '0.20.3' %}
{%- set server_root_dir = '/usr/local/graylog2-server-' + version %}
{%- set user = salt['pillar.get']('graylog2:server:user', 'graylog2') %}

graylog2-server:
  user:
    - absent
    - name: {{ user }}
    - require:
      - service: graylog2-server
  group:
    - absent
    - name: {{ user }}
    - require:
      - user: graylog2-server
  service:
    - dead

{%- for file in ('/etc/graylog2.conf', server_root_dir,
                '/etc/init/graylog2-server.conf', '/etc/rsyslog.d/graylog2-server.conf', '/etc/graylog2') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: graylog2-server
{% endfor %}

graylog2-upstart-log:
  cmd:
    - run
    - name: find /var/log/upstart/ -maxdepth 1 -type f -name 'graylog2.log*' -delete
    - require:
      - service: graylog2-server
