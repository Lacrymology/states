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
Maintainer: Dang Tung Lam <lamdt@familug.org>
-#}
include:
  - apt

{#-

Creating mariadb mirror:

    wget -m -I /repo/5.5/ubuntu/ http://mariadb.biz.net.id/repo/5.5/ubuntu/
    mv mariadb.biz.net.id/repo/5.5/ubuntu/{dist,pool} .
    rm -rf mariadb.biz.net.id/
    find . -type f -name 'index.*' -delete
    find pool/ -type f ! -name '*.deb' -delete

To keep only precise and trusty:

    find dists/ -maxdepth 1 -mindepth 1 ! \( -name precise -or -name trusty \) | xargs rm -r
    find pool/ \( -type f -name '*.deb' ! \( -name '*precise*' -or -name '*trusty*' \) \) -delete
#}

mariadb:
  pkgrepo:
    - managed
    - key_url: salt://mariadb/key.gpg
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive']|replace('https://', 'http://') }}/mirror/mariadb/5.5.39 {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - name: deb http://mariadb.biz.net.id//repo/5.5/ubuntu precise main
{%- endif %}
    - file: /etc/apt/sources.list.d/mariadb.list
    - require:
      - pkg: apt_sources
  pkg:
    - installed
    - name: libmysqlclient18
    - require:
      - pkgrepo: mariadb
      - pkg: mysql-common

mysql-common:
  pkg:
    - installed
    - require:
      - pkgrepo17: mariadb
