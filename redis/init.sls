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

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
{%- from 'macros.jinja2' import manage_pid with context %}

{%- set redis_version = "2.8.4" %}
{%- set jemalloc_version = "3.4.1" %}

{%- set redis_sub_version = "2:{0}-1chl1~{1}1".format(redis_version, grains['lsb_distrib_codename']) %}
{%- set jemalloc_sub_version = "{0}-1chl1~{1}1".format(jemalloc_version, grains['lsb_distrib_codename']) %}

{%- set jemalloc = "libjemalloc1_{0}-1chl1~{1}1_{2}.deb".format(jemalloc_version, grains['lsb_distrib_codename'], grains['debian_arch']) %}
{%- set filename = "redis-server_{0}-1chl1~{1}1_{2}.deb".format(redis_version, grains['lsb_distrib_codename'], grains['debian_arch']) %}
{%- set redistools = "redis-tools_{0}-1chl1~{1}1_{2}.deb".format(redis_version, grains['lsb_distrib_codename'], grains['debian_arch']) %}

redis:
  file:
    - managed
    - template: jinja
    - source: salt://redis/config.jinja2
    - name: /etc/redis/redis.conf
    - user: redis
    - group: redis
    - mode: 440
    - makedirs: True
    - require:
      - pkg: redis
  service:
    - running
    - enable: True
    - name: redis-server
    - order: 50
    - watch:
      - file: redis
      - pkg: redis
      - user: redis
  pkg:
    - installed
    - sources:
{%- if salt['pillar.get']('files_archive', False) %}
      - libjemalloc1: {{ salt['pillar.get']('files_archive', False)|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ jemalloc }}
      - redis-server: {{ salt['pillar.get']('files_archive', False)|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ filename }}
      - redis-tools: {{ salt['pillar.get']('files_archive', False)|replace('file://', '')|replace('https://', 'http://') }}/mirror/{{ redistools }}
{%- else %}
      - libjemalloc1: http://ppa.launchpad.net/chris-lea/redis-server/ubuntu/pool/main/j/jemalloc/{{ jemalloc }}
      - redis-server: http://ppa.launchpad.net/chris-lea/redis-server/ubuntu/pool/main/r/redis/{{ filename }}
      - redis-tools: http://ppa.launchpad.net/chris-lea/redis-server/ubuntu/pool/main/r/redis/{{ redistools }}
{%- endif %}
  user:
    - present
    - shell: /bin/false
    - require:
      - pkg: redis

{%- call manage_pid('/var/run/redis/redis-server.pid', 'redis', 'redis', 'redis-server') %}
- pkg: redis
{%- endcall %}

{%- if salt['pkg.version']('libjemalloc1') not in ('', jemalloc_sub_version) %}
jemalloc_old_version:
  pkg:
    - removed
    - name: libjemalloc1
    - require_in:
      - pkg: redis
{%- endif %}

{%- if salt['pkg.version']('redis-server') not in ('', redis_sub_version)  %}
redis_old_version:
  pkg:
    - removed
    - name: redis-server
    - require_in:
      - pkg: redis
{%- endif %}
