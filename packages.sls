{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- for i in salt['pillar.get']('packages:blacklist', []) -%}
    {%- if loop.first %}
packages_blacklist:
  pkg:
    - purged
    - pkgs:
    {%- endif %}
      - {{ i }}
{%- endfor -%}

{%- for i in salt['pillar.get']('packages:whitelist', []) -%}
    {%- if loop.first %}
packages_whitelist:
  pkg:
    - installed
    - pkgs:
    {%- endif %}
      - {{ i }}
{%- endfor -%}
