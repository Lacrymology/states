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

Uninstall a Salt API REST server.
-#}

salt_api:
  group:
    - absent
{% for user in salt['pillar.get']('salt_master:external_auth:pam', []) %}
{% if loop.first %}
    - require:
{% endif %}
      - user: user_{{ user }}
{% endfor %}

{# You need to set the password for each of those users #}
{% for user in salt['pillar.get']('salt_master:external_auth:pam', []) %}
user_{{ user }}:
  user:
    - absent
{% endfor %}

salt-api:
  pkg:
    - purged
    - require:
      - service: salt-api
{#{% if salt['cmd.has_exec']('pip') %}
  pip:
    - removed
    - name: cherrypy
    - require:
      - pkg: salt-api
{% endif %}#}
  file:
    - absent
    - name: /etc/init/salt-api.conf
    - require:
      - service: salt-api
  service:
    - dead

/etc/salt/master.d/ui.conf:
  file:
    - absent
    - require:
      - pkg: salt-api

/var/log/upstart/salt-api.log:
  file:
    - absent
    - require:
      - service: salt-api

/usr/local/salt-ui:
  file:
    - absent

/etc/nginx/conf.d/salt.conf:
  file:
    - absent

salt-api-requirements:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/salt.api

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/salt-api-requirements.txt:
  file:
    - absent

/etc/rsyslog.d/salt-api-upstart.conf:
  file:
    - absent
