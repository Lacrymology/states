{#-
Copyright (c) 2013, Lam Dang Tung
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

Author: Lam Dang Tung <lamdt@familug.org>
Maintainer: Lam Dang Tung <lamdt@familug.org>
-#}

include:
  - build
  - openldap.dev
  - nginx
  - pip
  - postgresql.server
  - python.dev
{%- if salt['pillar.get']('openerp:ssl', False) %}
  - ssl
{%- endif %}
  - underscore
  - uwsgi
  - virtualenv
  - web
  - xml
  - yaml

{%- set home = "/usr/local/openerp" %}
{%- set filename = "openerp-7.0-20130909-231057" %}
{%- set web_root_dir =  home +"/"+ filename %}
{%- set password = salt['password.pillar']('openerp:db:password', 10)  %}
{%- set username = salt['pillar.get']('openerp:db:username', 'openerp') %}

openerp_depends:
  file:
    - managed
    - name: {{ home }}/salt-openerp-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://openerp/requirements.jinja2
    - require:
      - file: /usr/local
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: {{ home }}/bin/pip
    - requirements: {{ home }}/salt-openerp-requirements.txt
    - install_options:
      - "--prefix={{ home }}"
      - "--install-lib={{ home }}/lib/python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}/site-packages"
    - require:
      - virtualenv: openerp
    - watch:
      - file: openerp_depends
      - pkg: python-dev
      - pkg: ldap-dev
      - pkg: postgresql-dev
      - pkg: build
      - pkg: libjs-underscore
      - pkg: xml-dev
      - pkg: yaml
  cmd:
    - wait
    - name: find {{ home }} -name '*.pyc' -delete
    - stateful: False
    - user: root
    - watch:
      - module: openerp_depends

openerp:
  user:
    - present
    - shell: /bin/false
    - home: {{ home }}
    - groups:
      - www-data
    - require:
      - user: web
      - file: /usr/local
  virtualenv:
    - managed
    - name: {{ home }}
    - require:
      - user: openerp
      - module: virtualenv
  postgres_user:
    - present
    - name: {{ username }}
    - password: {{ password }}
    - createdb: True
    - require:
      - service: postgresql
  file:
    - directory
    - name: {{ home }}
    - user: openerp
    - group: openerp
    - recurse:
      - user
      - group
    - require:
      - archive: openerp
      - user: openerp
      - cmd: openerp_depends
  archive:
    - extracted
    - name: {{ home }}/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/openerp/{{ filename }}.tar.gz
{%- else %}
    - source: http://nightly.openerp.com/7.0/nightly/src/{{ filename }}.tar.gz
{%- endif %}
    - source_hash: md5=0e139452d2f0bcd8f09b0a494b3ac839
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_root_dir }}
    - require:
      - file: /usr/local

{{ web_root_dir }}/openerp.wsgi:
  file:
    - managed
    - user: openerp
    - group: openerp
    - mode: 440
    - template: jinja
    - source: salt://openerp/openerp.jinja2
    - require:
      - file: openerp
    - context:
      password: {{ password }}
      username: {{ username }}
      web_root_dir: {{ web_root_dir }}

add_web_user_to_openerp_group:
  user:
    - present
    - name: www-data
    - groups:
      - openerp
    - require:
      - user: web
      - user: openerp

uwsgi_openerp:
  uwsgi:
    - available
    - enabled: True
    - name: openerp
    - template: jinja
    - source: salt://openerp/uwsgi.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - context:
      web_root_dir: {{ web_root_dir }}
      home: {{ home }}
    - require:
      - user: add_web_user_to_openerp_group
      - service: uwsgi_emperor
      - postgres_user: openerp
      - file: openerp
    - watch:
      - module: openerp_depends
      - archive: openerp
      - file: {{ web_root_dir }}/openerp.wsgi
      - cmd: openerp_depends

/etc/nginx/conf.d/openerp.conf:
  file:
    - managed
    - source: salt://openerp/nginx.jinja2
    - template: jinja
    - group: www-data
    - user: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - uwsgi: uwsgi_openerp
{%- if salt['pillar.get']('openerp:ssl', False) %}
      - cmd: /etc/ssl/{{ pillar['openerp']['ssl'] }}/chained_ca.crt
      - module: /etc/ssl/{{ pillar['openerp']['ssl'] }}/server.pem
      - file: /etc/ssl/{{ pillar['openerp']['ssl'] }}/ca.crt
{%- endif %}
    - watch_in:
      - service: nginx
    - context:
      web_root_dir: {{ web_root_dir }}

{%- if salt['pillar.get']('openerp:ssl', False) %}
extend:
  nginx:
    service:
      - watch:
        - cmd: /etc/ssl/{{ pillar['openerp']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['openerp']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['openerp']['ssl'] }}/ca.crt
{% endif %}
