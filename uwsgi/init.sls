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
 
 Install uWSGI Web app server.
 This build come with only Python support.

 To turn on Ruby support, include uwsgi.ruby instead of this file.
 For PHP include uwsgi.php instead.
 You can include both uwsgi.php and uwsgi.ruby.
-#}
include:
  - git
  - local
  - nginx
  - pip
  - web
  - xml
  - python.dev
  - rsyslog

/etc/init/uwsgi.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://uwsgi/upstart.jinja2

uwsgi_build:
{%- if 'files_archive' in pillar -%}
  {%- set uwsgi_download_module = "archive" %}
  archive:
    - extracted
    - name: /usr/local
    - source: {{ pillar['files_archive'] }}/mirror/uwsgi-1.4.3-patched.tar.gz
    - source_hash: md5=7e906d84fd576bccd1a3bb7ab308ec3c
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/uwsgi
    - require:
      - file: /usr/local
{%- else -%}
  {%- set uwsgi_download_module = "git" %}
  git:
    - latest
    - name: git://github.com/bclermont/uwsgi.git
    - rev: 1.4.3-patched
    - target: /usr/local/uwsgi
    - require:
      - pkg: git
      - file: /usr/local
{%- endif %}
  file:
    - managed
    - name: /usr/local/uwsgi/buildconf/custom.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://uwsgi/buildconf.jinja2
    - require:
      - {{ uwsgi_download_module }}: uwsgi_build
  cmd:
    - wait
    - name: python uwsgiconfig.py --clean; python uwsgiconfig.py --build custom
    - cwd: /usr/local/uwsgi
    - stateful: false
    - watch:
      - pkg: xml-dev
      - {{ uwsgi_download_module }}: uwsgi_build
      - file: uwsgi_build
      - pkg: python-dev

uwsgi_sockets:
  file:
    - directory
    - name: /var/lib/uwsgi
    - user: www-data
    - group: www-data
    - mode: 770
    - require:
      - user: web
      - cmd: uwsgi_build
      - {{ uwsgi_download_module }}: uwsgi_build
      - file: uwsgi_build

uwsgi_emperor:
  cmd:
    - wait
    - name: strip /usr/local/uwsgi/uwsgi
    - stateful: false
    - watch:
      - {{ uwsgi_download_module }}: uwsgi_build
      - file: uwsgi_build
      - cmd: uwsgi_build
  service:
    - running
    - name: uwsgi
    - enable: True
    - order: 50
    - require:
      - file: uwsgi_emperor
      - file: uwsgi_sockets
      - service: rsyslog
    - watch:
      - cmd: uwsgi_emperor
      - file: /etc/init/uwsgi.conf
  file:
    - directory
    - name: /etc/uwsgi
    - user: www-data
    - group: www-data
    - mode: 550
    - require:
      - user: web
