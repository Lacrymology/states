{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
mercurial:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/mercurial
{%- if salt['cmd.has_exec']('pip') %}
  pip:
    - removed
    - order: 1
{%- endif %}
