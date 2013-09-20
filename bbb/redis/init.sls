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
  - debian.package_build
  - redis

{%- set bbb_dir = opts['cachedir'] + "/bbb" -%}
{%- set redis_dir = bbb_dir + "/redis" -%}
{%- set filenames = ('control', 'changelog', 'rules') -%}

{%- set version = "2.2.4" %}

{{ redis_dir }}/debian:
  file:
    - name:
    - directory
    - makedirs: True

{%- for filename in filenames %}
{{ redis_dir }}/debian/{{ filename }}:
  file:
    - managed
    - source: salt://bbb/redis/{{ filename }}.jinja2
    - template: jinja
    - context:
      package_name: redis-server-{{ version }}
      version: {{ version }}
      depends: redis-server
      description: Virtual package that depends on redis-server
{%- endfor %}

redis_package:
  cmd:
    - wait
    - name: dpkg-buildpackage
    - cwd: {{ redis_dir }}
    - watch:
{%- for filename in filenames %}
      - file: {{ redis_dir }}/debian/{{ filename }}
{%- endfor %}
    - require:
      - pkg: package_build
  module:
    - wait
    - name: pkg.install
    - m_name: redis-server-{{ version }}
    - sources:
      - redis-server-{{ version }}: {{ bbb_dir }}/redis-server-{{ version }}_{{ version }}_all.deb
    - require:
      - pkg: redis
    - watch:
      - cmd: redis_package
