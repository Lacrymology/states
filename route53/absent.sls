{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
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

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/salt-route53-requirements.txt:
  file:
    - absent
