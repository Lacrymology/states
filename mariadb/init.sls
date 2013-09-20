{#-
Copyright (c) 2013 Hung Nguyen Viet

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Author: Hung Nguyen Viet hvnsweeting@gmail.com
Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - apt

mariadb:
  pkgrepo:
    - managed
    - keyid: '0xcbcb082a1bb943db'
    - keyserver: keyserver.ubuntu.com
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive'] }}/mirror/mariadb/5.5.31 {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - name: deb http://repo.maxindo.net.id/mariadb/repo/5.5/ubuntu precise main
{%- endif %}
    - file: /etc/apt/sources.list.d/mariadb.list
    - require:
      - pkg: apt_sources
  pkg:
    - installed
    - name: libmysqlclient18
    - version: 5.5.31+maria-1~precise
    - require:
      - pkgrepo: mariadb
      - pkg: mysql-common
{#- prevent dist_upgrade #}
  cmd:
    - run
    - name: echo libmysqlclient18 hold | dpkg --set-selections
    - unless: dpkg --get-selections | grep libmysqlclient18 | grep -q hold
    - require:
      - pkg: mariadb

{#- specify version to prevent conflict with mysql #}
mysql-common:
  pkg:
    - installed
    - version: 5.5.31+maria-1~precise
    - require:
      - pkgrepo: mariadb

hold_mysql_common:
  cmd:
    - run
    - name: echo mysql-common hold | dpkg --set-selections
    - unless: dpkg --get-selections | grep mysql-common | grep -q hold
    - require:
      - pkg: mariadb
