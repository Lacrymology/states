{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

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
