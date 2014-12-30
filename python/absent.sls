{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{#- use this ID to make it conflict with python/init.sls #}
/etc/python:
  file:
    - absent
    - require:
      - file: python

/etc/python/logging.conf:
  file:
    - absent

python:
  file:
    - absent
    - name: /etc/python/config.yml

{%- for log_file in salt['file.find']('/usr/lib/python2.7/', name='*.pyo', type='f') %}
{{ log_file }}:
  file:
    - absent
{%- endfor -%}
