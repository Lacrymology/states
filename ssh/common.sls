{%- macro root_home() -%}
{{ salt['user.info']('root')['home'] }}
{%- endmacro  %}

{{ root_home() }}/.ssh:
  file:
    - directory
    - user: root
    - group: root
    - mode: 700
