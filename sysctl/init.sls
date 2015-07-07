{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - kernel.modules

{%- for key in salt['pillar.get']('sysctl', {}) %}
{%- set name = key|replace(':','.') %}
sysctl_{{ name }}:
  sysctl:
    - present
    - name: {{ name }}
    - value: {{ salt['pillar.get']('sysctl:' ~ key, False) }}
    - require:
      - file: kernel_modules
    - require_in:
      - file: sysctl
{%- endfor %}

sysctl: {# API #}
  file:
    - managed
    - name: /etc/sysctl.conf
    - user: root
    - group: root
    - mode: 644
    - replace: False
