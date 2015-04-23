{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set cmd = 'redis-cli' -%}
{%- set arg = 'flushall' -%}

{{ cmd }}-{{ arg }}:
  cmd:
    - run
{%- if salt['cmd.has_exec'](cmd) %}
    - name: {{ cmd }}
{%- else %}
    - name: echo "Redis not yet installed"
{%- endif %}
