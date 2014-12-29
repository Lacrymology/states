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

Author: Lam Dang Tung <lam@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - apt
{%- set version = '1.4.2-1chl1~precise1' %}
libjs-underscore:
  pkgrepo:
    - managed
{%- if salt['pillar.get']('files_archive', False) %}
    - name: deb {{ salt['pillar.get']('files_archive', False)|replace('https://', 'http://') }}/mirror/underscore/1.4.2-1 {{ grains['lsb_distrib_codename'] }} main
    - key_url: salt://underscore/key.gpg
{%- else %}
    - ppa: chris-lea/libjs-underscore
{%- endif %}
    - file: /etc/apt/sources.list.d/chris-lea-libjs-underscore-{{ grains['oscodename'] }}.list
    - require:
      - cmd: apt_sources
  pkg:
    - installed
    - version: {{ version }}
    - require:
      - pkgrepo: libjs-underscore
      - cmd: apt_sources
