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

Install an OpenSSH secure shell server.
-#}
include:
  - apt
  - local
  - rsyslog

openssh-server:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/ssh/sshd_config
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://ssh/server/config.jinja2
    - require:
      - pkg: openssh-server
  service:
    - running
    - enable: True
    - order: 50
    - name: ssh
    - require:
      - service: rsyslog
    - watch:
      - pkg: openssh-server
      - file: openssh-server
{#- PID file owned by root, no need to manage #}

{% for user in salt['pillar.get']('root_keys', []) -%}
  {% for key in salt['pillar.get']('root_keys:' ~ user, []) -%}
ssh_server_root_{{ key }}:
  ssh_auth:
    - present
    - name: {{ key }}
    - user: root
    - enc: {{ pillar['root_keys'][user][key] }}
    - options:
      - command="/usr/local/bin/root-shell-wrapper {{ user }}"
    - require:
      - file: /usr/local/bin/root-shell-wrapper
    - require_in:
      - service: openssh-server
  {% endfor %}
{% endfor %}

/usr/local/bin/root-shell-wrapper:
  file:
    - managed
    - source: salt://ssh/server/root-shell-wrapper.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /usr/local
