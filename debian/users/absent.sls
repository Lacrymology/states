{%- for filename in ('passwd', 'group', 'shadow') %}
/etc/{{ filename }}.org:
  file:
    - absent
{%- endfor -%}
