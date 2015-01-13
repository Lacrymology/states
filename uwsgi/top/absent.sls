{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
uwsgitop:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/uwsgi.top

{#
{% if salt['cmd.has_exec']('pip') %}
uwsgitop:
  pip:
    - removed
{% endif %}
#}
