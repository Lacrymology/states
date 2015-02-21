{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- for key in salt['pillar.get']('sysctl', {}) %}

{{ key|replace(':','.') }}:
  sysctl:
    - present
    - value: {{ salt['pillar.get']('sysctl:' ~ key, False) }}
{%- endfor %}
