{#-
Copyright (c) 2014, Diep Pham
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

Author: Diep Pham <imeo@favadi.com>
Maintainer: Diep Pham <imeo@favadi.com>

Install geminabox (https://github.com/geminabox/geminabox)
-#}

include:
  - local
  - nginx
  - uwsgi.ruby
  - ruby
  - web

/usr/local/geminabox:
  file:
    - directory
    - user: geminabox
    - group: geminabox
    - mode: 750
    - require:
      - user: geminabox
      - file: /usr/local

geminabox:
  user:
    - present
    - groups:
      - www-data
    - require:
      - user: web
  gem:
    - installed
    - name: bundler
    - version: 1.7.3
    - user: root
    - require:
      - pkg: ruby
  file:
    - managed
    - name: /usr/local/geminabox/Gemfile
    - source: salt://geminabox/Gemfile
    - user: geminabox
    - group: geminabox
    - mode: 440
    - require:
      - file: /usr/local/geminabox
  cmd:
    - wait
    - name: bundle install --deployment
    - user: geminabox
    - cwd: /usr/local/geminabox
    - require:
      - gem: geminabox
    - watch:
      - file: /usr/local/geminabox/Gemfile.lock

/usr/local/geminabox/Gemfile.lock:
  file:
    - managed
    - source: salt://geminabox/Gemfile.lock
    - user: geminabox
    - group: geminabox
    - mode: 440
    - require:
      - file: /usr/local/geminabox/Gemfile

/var/lib/geminabox-data:
  file:
    - directory
    - user: geminabox
    - group: geminabox
    - mode: 750
    - require:
      - user: geminabox

/usr/local/geminabox/config.ru:
  file:
    - managed
    - source: salt://geminabox/config.ru
    - user: geminabox
    - group: geminabox
    - mode: 440
    - require:
      - file: /usr/local/geminabox/Gemfile
      - file: /var/lib/geminabox-data

geminabox-uwsgi:
  file:
    - managed
    - name: /etc/uwsgi/geminabox.yml
    - source: salt://geminabox/uwsgi.jinja2
    - template: jinja
    - user: geminabox
    - group: geminabox
    - mode: 440
    - context:
      appname: geminabox
      chdir: /usr/local/geminabox
      rack: config.ru
      uid: geminabox
      gid: geminabox
    - require:
      - cmd: geminabox
      - service: uwsgi_emperor
      - file: /usr/local/geminabox/config.ru
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/geminabox.yml
    - require:
      - file: geminabox
    - watch:
      - cmd: geminabox
      - file: /usr/local/geminabox/config.ru

/etc/nginx/conf.d/geminabox.conf:
  file:
    - managed
    - source: salt://geminabox/nginx.jinja2
    - template: jinja
    - group: www-data
    - user: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - user: web
      - file: geminabox-uwsgi
{%- if salt['pillar.get']('gitlab:ssl', False) %}
      - cmd: ssl_cert_and_key_for_{{ pillar['geminabox']['ssl'] }}
{%- endif %}
    - watch_in:
      - service: nginx
