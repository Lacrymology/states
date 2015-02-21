{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- macro root_home() -%}
{{ salt['user.info']('root')['home'] }}
{%- endmacro  %}

{{ root_home() }}/.ssh:
  file:
    - directory
    - user: root
    - group: root
    - mode: 700
