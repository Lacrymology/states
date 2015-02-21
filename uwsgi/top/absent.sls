{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
