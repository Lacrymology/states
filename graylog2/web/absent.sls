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

Uninstall a graylog2 web interface server.
-#}
{% set version = '0.20.3' %}
{% set web_root_dir = '/usr/local/graylog2-web-interface-' + version %}
{% set user = salt['pillar.get']('graylog2:web:user', 'graylog2-ui') %}

/etc/logrotate.d/graylog2-web:
  file:
    - absent

graylog2-web:
  user:
    - absent
    - name: {{ user }}
    - require:
      - service: graylog2-web
  group:
    - absent
    - name: {{ user }}
    - require:
      - service: graylog2-web
  service:
    - dead
    - enable: False

{% for file in ('/etc/nginx/conf.d/graylog2-web.conf', web_root_dir, '/etc/init/graylog2-web.conf') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: graylog2-web
{% endfor %}

{% for command in ('streamalarms', 'subscriptions') %}
/etc/cron.hourly/graylog2-web-{{ command }}:
  file:
    - absent
{% endfor %}

graylog2-web-prep:
  service:
    - dead
    - require:
      - service: graylog2-web
  file:
    - managed
    - name: /etc/init/graylog2-web-prep.conf
    - require:
      - service: graylog2-web-prep
