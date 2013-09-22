{#-
Copyright (c) 2013, Hung Nguyen Viet

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

Author: Hung Nguyen Viet <hvnsweeting@gmail.com>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>
 
Install Redis
-#}

{% set jemalloc = "libjemalloc1_3.4.0-1chl1~{0}1_{1}.deb".format(grains['lsb_distrib_codename'], grains['debian_arch']) %}
{% set filename = "redis-server_2.6.14-1chl1~{0}1_{1}.deb".format(grains['lsb_distrib_codename'], grains['debian_arch']) %}

redis:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - libjemalloc1: {{ pillar['files_archive']|replace('file://', '') }}/mirror/{{ jemalloc }}
      - redis-server: {{ pillar['files_archive']|replace('file://', '') }}/mirror/{{ filename }}
{%- else %}
      - libjemalloc1: http://ppa.launchpad.net/chris-lea/redis-server/ubuntu/pool/main/j/jemalloc/{{ jemalloc }}
      - redis-server: http://ppa.launchpad.net/chris-lea/redis-server/ubuntu/pool/main/r/redis/{{ filename }}
{%- endif %}
  file:
    - managed
    - template: jinja
    - source: salt://redis/config.jinja2
    - name: /etc/redis/redis.conf
    - makedirs: True
    - require:
      - pkg: redis
  service:
    - running
    - name: redis-server
    - order: 50
    - watch:
      - file: redis
      - pkg: redis
