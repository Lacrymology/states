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
  - local
  - nginx
  - openldap.dev
  - pip
{%- if salt['pillar.get']('moinmoin:ldap', False) %}
  - python.dev
{%- endif %}
  - uwsgi
  - virtualenv
  - web

{%- set root_dir = '/usr/local/moinmoin' %}

moinmoin:
  virtualenv:
    - manage
    - name: /usr/local/moinmoin
    - system_site_packages: False
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
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/moinmoin/bin/pip
    - requirements: /usr/local/moinmoin/salt-requirements.txt
    - watch:
      - file: moinmoin
{%- if salt['pillar.get']('moinmoin:ldap', False) %}
    - require:
      - pkg: ldap-dev
      - pkg: python-dev
{%- endif %}
  cmd:
    - wait
    - name: find /usr/local/moinmoin -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: moinmoin
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
      - user: web
    - watch:
      - file: moinmoin
      - file: moinmoin_config
      - file: {{ root_dir }}/share/moin
      - file: {{ root_dir }}/share/moin/moin.wsgi

{{ root_dir }}/share:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 550
    - require:
      - cmd: moinmoin
      - user: web

{{ root_dir }}/share/moin:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 550
    - recurse:
      - user
      - group
    - require:
      - file: {{ root_dir }}/share

{{ root_dir }}/share/moin/moin.wsgi:
  file:
    - symlink
    - target: {{ root_dir }}/share/moin/server/moin.wsgi
    - user: www-data
    - group: www-data
    - mode: 440
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
      - uwsgi: moinmoin

/var/lib/deployments:
  file:
    - directory
    - user: root
    - group: root
    - mode: 555
    - makedirs: True

/var/lib/deployments/moinmoin:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 550
    - require:
      - user: web
      - file: /var/lib/deployments

/var/lib/deployments/moinmoin/data:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 770
    - recurse:
      - user
      - group
    - require:
      - module: /var/lib/deployments/moinmoin/data
    - require_in:
      - uwsgi: moinmoin
  module:
    - wait
    - name: file.rename
    - src: /usr/local/moinmoin/share/moin/data
    - dst: /var/lib/deployments/moinmoin/data
    - watch:
      - module: moinmoin
    - require:
      - file: /var/lib/deployments/moinmoin

/var/lib/deployments/moinmoin/underlay:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 550
    - require:
      - file: /var/lib/deployments/moinmoin

/var/lib/deployments/moinmoin/underlay/pages:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 770
    - require:
      - module: /var/lib/deployments/moinmoin/underlay/pages
    - recurse:
      - user
      - group
    - require_in:
      - uwsgi: moinmoin
  module:
    - wait
    - name: file.rename
    - src: /usr/local/moinmoin/share/moin/underlay/pages
    - dst: /var/lib/deployments/moinmoin/underlay/pages
    - watch:
      - module: moinmoin
    - require:
      - file: /var/lib/deployments/moinmoin/underlay

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/moinmoin.conf
