{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

route53:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/route53
{%- if salt['cmd.has_exec']('pip') %}
  pip:
    - removed
    - order: 1
{%- endif %}
