{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

virtualenv:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/virtualenv
{% if salt['cmd.has_exec']('pip') %}
  pip:
    - removed
    - order: 1
{% endif %}
