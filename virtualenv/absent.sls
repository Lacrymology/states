{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
virtualenv:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/virtualenv
{% if salt['cmd.has_exec']('pip') %}
  pip:
    - removed
    - order: 1
{% endif %}

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/salt-virtualenv-requirements.txt:
  file:
    - absent
