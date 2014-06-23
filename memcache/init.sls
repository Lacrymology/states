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

Install a memcache server.
-#}
include:
  - apt
  - rsyslog
  - web

{#
 first: install memcached and get rid of SysV startup script.
 and remove it's config file.
#}
{#- does not use PID, no need to manage #}
memcached:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  module:
    - wait
    - name: cmd.run
    - cmd: /etc/init.d/memcached stop
    - watch:
      - pkg: memcached
  cmd:
    - wait
    - name: update-rc.d -f memcached remove
    - watch:
      - module: memcached
  file:
    - absent
    - name: /etc/init.d/memcached
    - watch:
      - cmd: memcached
  service:
    - running
    - name: memcached
    - enable: True
    - order: 50
    - require:
      - file: memcached
    - watch:
      - user: web
      - file: upstart_memcached

/etc/memcached.conf:
  file:
    - absent
    - require:
      - pkg: memcached

{#
 Create upstart config and start from it.
#}
upstart_memcached:
  file:
    - managed
    - name: /etc/init/memcached.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://memcache/upstart.jinja2
    - require:
      - file: memcached
      - user: web

{% from 'rsyslog/upstart.sls' import manage_upstart_log with context %}
{{ manage_upstart_log('memcached') }}
