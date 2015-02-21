{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
