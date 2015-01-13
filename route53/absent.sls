{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
route53:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/route53
{%- if salt['cmd.has_exec']('pip') %}
  pip:
    - removed
    - order: 1
{%- endif %}
