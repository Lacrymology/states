{#-
Copyright (C) 2013 the Institute for Institutional Innovation by Data
Driven Design Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE  MASSACHUSETTS INSTITUTE OF
TECHNOLOGY AND THE INSTITUTE FOR INSTITUTIONAL INNOVATION BY DATA
DRIVEN DESIGN INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the names of the Institute for
Institutional Innovation by Data Driven Design Inc. shall not be used in
advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from the
Institute for Institutional Innovation by Data Driven Design Inc.

Author: Hung Nguyen Viet <hvnsweeting@gmail.com>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>
 -#}
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
      - user: web

{{ root_dir }}/share/moin/moin.wsgi:
  file:
    - symlink
    - target: {{ root_dir }}/share/moin/server/moin.wsgi
    - user: www-data
    - group: www-data
    - require:
      - cmd: moinmoin
      - user: web

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
      - user: web

uwsgi_moinmoin:
  uwsgi:
    - available
    - enabled: True
    - name: moinmoin
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
      - file: /var/lib/deployments/moinmoin
      - user: web
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
      - user: web

/var/lib/deployments:
  file:
    - directory
    - user: www-data
    - group: www-data
    - makedirs: True
    - require:
      - user: web

moinmoin_move_data_to_right_place:
  cmd:
    - wait
    - name: mv /usr/local/moinmoin/share/moin/data /var/lib/deployments/moinmoin
    - watch:
      - module: moinmoin
    - require:
      - file: /var/lib/deployments

/var/lib/deployments/moinmoin:
  file:
    - directory
    - user: www-data
    - group: www-data
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: web
      - cmd: moinmoin_move_data_to_right_place

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/moinmoin.conf
