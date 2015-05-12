{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- for key in salt['pillar.get']('sysctl', {}) %}

{{ key|replace(':','.') }}:
  sysctl:
    - present
    - value: {{ salt['pillar.get']('sysctl:' ~ key, False) }}
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
