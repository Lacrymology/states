{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
hostname:
  file:
    - managed
    - template: jinja
    - name: /etc/hostname
    - user: root
    - group: root
    - mode: 444
    - source: salt://hostname/hostname.jinja2
  host:
    - present
    - name: {{ grains['id'] }}
    - ip: 127.0.0.1
    - require:
      - cmd: hostname
  cmd:
{%- if grains['id'] != grains['localhost'] %}
    - run
{%- else %}
    - wait
{%- endif %}
    - name: hostname `cat /etc/hostname`
    - watch:
      - file: hostname
