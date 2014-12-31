{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
raven:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/raven
{% if salt['cmd.has_exec']('pip') %}
  pip:
    - name: raven
    - removed
    - order: 1
{% endif %}

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/raven-requirements.txt:
 file:
   - absent
