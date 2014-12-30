{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
uwsgitop:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/uwsgi.top

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/salt-uwsgitop-requirements.txt:
  file:
    - absent

{#
{% if salt['cmd.has_exec']('pip') %}
uwsgitop:
  pip:
    - removed
{% endif %}
#}
