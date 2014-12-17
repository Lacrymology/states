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
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
include:
  - apt
  - local
  - rsyslog
  - ssh.common

{%- from 'ssh/common.sls' import root_home with context %}

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

ssh_server_root_authorized_keys:
  file:
    - managed
    - name: {{ root_home() }}/.ssh/authorized_keys
    - mode: 400
    - contents: |
{%- for user in salt['pillar.get']('root_keys', {}) -%}
  {%- for key, type in salt['pillar.get']('root_keys:' ~ user, {}).iteritems() %}
        command="/usr/local/bin/root-shell-wrapper {{ user }}" {{ type }} {{ key }}
  {%- endfor -%}
{%- endfor %}
    - require:
      - file: {{ root_home() }}/.ssh

/usr/local/bin/root-shell-wrapper:
  file:
    - managed
    - source: salt://ssh/server/root-shell-wrapper.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /usr/local

/etc/rsyslog.d/ssh.conf:
  file:
{% if not salt['pillar.get']('debug', False) and salt['pillar.get']('shinken_pollers', []) %}
    - managed
    - template: jinja
    - source: salt://ssh/server/rsyslog.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog
{% else %}
    - absent
{% endif %}
