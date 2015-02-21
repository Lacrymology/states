{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- for filename in ('passwd', 'group', 'shadow') %}
/etc/{{ filename }}.org:
  file:
    - absent
{%- endfor -%}
