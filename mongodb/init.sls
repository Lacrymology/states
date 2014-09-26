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

Install a MongoDB NoSQL server.

If one day MongoDB support SSL in free distribution, do this:
http://docs.mongodb.org/manual/tutorial/configure-ssl/
-#}
include:
  - locale
  - logrotate

{% set version = '2.4.9' %}
{% set filename = 'mongodb-10gen_' + version + '_' + grains['debian_arch'] + '.deb' %}

mongodb:
  file:
    - managed
    - name: /etc/logrotate.d/mongodb
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/logrotate.jinja2
    - require:
      - pkg: logrotate
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - pkg: mongodb
      - file: /etc/mongodb.conf
      - user: mongodb
  pkg:
    - installed
    - require:
      - cmd: system_locale
    - sources:
{%- if 'files_archive' in pillar %}
      - mongodb-10gen: {{ pillar['files_archive']|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ filename }}
{%- else %}
      - mongodb-10gen: http://downloads-distro.mongodb.org/repo/ubuntu-upstart/dists/dist/10gen/binary-{{ grains['debian_arch'] }}/{{ filename }}
{%- endif %}
  user:
    - present
    - shell: /bin/false
    - require:
      - pkg: mongodb

{#- does not use PID, no need to manage #}

{%- if salt['pkg.version']('mongodb-10gen') not in ('', version) %}
mongodb_old_version:
  pkg:
    - removed
    - name: mongodb
    - require_in:
      - pkg: mongodb
{%- endif %}

mongodb_old_apt_repo:
  file:
    - name: /etc/apt/sources.list.d/downloads-distro.mongodb.org-repo_ubuntu-upstart-dist.list
    - absent

/etc/mongodb.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://mongodb/config.jinja2
    - require:
      - pkg: mongodb
