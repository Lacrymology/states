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

Install Salt Minion (client).
-#}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
  - pysc
  - raven
  - requests
  - rsyslog
  - salt.minion.upgrade
  - sudo

{# it's mandatory to remove this file if the master is changed #}
salt_minion_master_key:
  module:
    - wait
    - name: file.remove
    - path: /etc/salt/pki/minion/minion_master.pub
    - watch:
      - file: salt-minion
    - watch_in:
      - service: salt-minion

{{ opts['cachedir'] }}/pkg_installed.pickle:
  file:
    - absent

{{ manage_upstart_log('salt-minion') }}

extend:
  salt-minion:
    service:
      - require:
        - service: rsyslog
    pkg:
      - installed
      - require:
        - pkgrepo: salt
        - cmd: apt_sources
        - pkg: apt_sources

salt-fire-event:
  group:
    - present

/etc/sudoers.d/salt_fire_event:
  file:
    - managed
    - template: jinja
    - source: salt://salt/minion/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo
      - group: salt-fire-event

/usr/local/bin/salt_fire_event.py:
  file:
    - managed
    - template: jinja
    - source: salt://salt/minion/salt_fire_event.py
    - mode: 551
    - user: root
    - group: root
    - require:
      - pkg: salt-minion
      - module: pysc
