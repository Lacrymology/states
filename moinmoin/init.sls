{#-
Copyright (c) 2013, Hung Nguyen Viet
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

Author: Hung Nguyen Viet hvnsweeting@gmail.com
Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
-#}
{#-

optional pillar:

moinmoin:
  sitename: Your company name
  superusers:
    - spiderman
    - batman
  ldap: # config ldap as backend authenticate for moinmoin
    uri: 'ldap://example.com
    binddn: 'cn=admin,dc=example,dc=com'
    bindpw: 'passwordhere'
    basedn: 'dc=example,dc=com'
    ssl: idoic # config moinmoin use ldap with TLS for authenticate. See ssl/init.sls for more

#}
include:
  - virtualenv
  - uwsgi
  - local
  - nginx
  - pip
{%- if salt['pillar.get']('moinmoin:ldap', False) %}
  - openldap.dev
  - python.dev
{%- endif %}
  - web

{%- set root_dir = '/usr/local/moinmoin' %}

moinmoin:
  virtualenv:
    - manage
    - name: /usr/local/moinmoin
    - no_site_packages: True
    - require:
      - module: virtualenv
      - file: /usr/local
  file:
    - managed
    - name: /usr/local/moinmoin/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://moinmoin/requirements.jinja2
    - require:
      - virtualenv: moinmoin
  cmd:
    - wait
    - name: find /usr/local/moinmoin -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: moinmoin
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/moinmoin/bin/pip
    - requirements: /usr/local/moinmoin/salt-requirements.txt
    - watch:
      - file: moinmoin
    - require:
      - virtualenv: moinmoin
{%- if salt['pillar.get']('moinmoin:ldap', False) %}
      - pkg: ldap-dev
      - pkg: python-dev
{%- endif %}

{{ root_dir }}/share/moin:
  file:
    - directory
    - user: www-data
    - group: www-data
    - recurse:
      - user
      - group
    - require:
      - cmd: moinmoin

{{ root_dir }}/share/moin/moin.wsgi:
  file:
    - symlink
    - target: {{ root_dir }}/share/moin/server/moin.wsgi
    - user: www-data
    - group: www-data
    - require:
      - cmd: moinmoin

moinmoin_config:
  file:
    - managed
    - name: {{ root_dir }}/share/moin/wikiconfig.py
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://moinmoin/config.jinja2
    - require:
      - virtualenv: moinmoin

/etc/uwsgi/moinmoin.ini:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://uwsgi/template.jinja2
    - context:
      chdir: /usr/local/moinmoin/share/moin/
      appname: moinmoin
      wsgi_file: /usr/local/moinmoin/share/moin/moin.wsgi
      virtualenv: {{ root_dir }}
    - require:
      - service: uwsgi_emperor
      - file: moinmoin
      - file: moinmoin_config
      - file: {{ root_dir }}/share/moin
      - file: {{ root_dir }}/share/moin/moin.wsgi
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/moinmoin.ini
    - require:
      - file: /etc/uwsgi/moinmoin.ini
    - watch:
      - file: moinmoin
      - file: moinmoin_config
      - file: {{ root_dir }}/share/moin
      - file: {{ root_dir }}/share/moin/moin.wsgi

/etc/nginx/conf.d/moinmoin.conf:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://nginx/template.jinja2
    - context:
      appname: moinmoin
      root: {{ root_dir }}/share/moin
    - require:
      - pkg: nginx

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/moinmoin.conf
