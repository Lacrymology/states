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

Install Denyhosts used to block SSH brute-force attack.
-#}
include:
  - apt
  - local
  - pysc
  - rsyslog

denyhosts-allowed:
  file:
    - managed
    - name: /var/lib/denyhosts/allowed-hosts
    - source: salt://denyhosts/allowed.jinja2
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - require:
      - pkg: denyhosts

denyhosts:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - source: salt://denyhosts/config.jinja2
    - name: /etc/denyhosts.conf
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - require:
      - pkg: denyhosts
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - file: denyhosts
      - pkg: denyhosts
      - file: denyhosts-allowed
    - require:
      - service: rsyslog
{#- PID file owned by root, no need to manage #}

/usr/local/bin/denyhosts-unblock:
  file:
    - managed
    - source: salt://denyhosts/denyhosts-unblock.py
    - user: root
    - group: root
    - mode: 500
    - require:
      - pkg: denyhosts
      - file: /usr/local
      - module: pysc

{% for file in ('/etc/logrotate.d/denyhosts', '/var/log/denyhosts') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: denyhosts
{% endfor %}
