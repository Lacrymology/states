{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set roles = ('broker', 'arbiter', 'reactionner', 'poller', 'scheduler', 'receiver') -%}

{% if salt['file.directory_exists']('/usr/local/shinken') %}
    {%- for role in roles -%}
        {%- if salt['file.file_exists']('/etc/init/shinken-' + role + '.conf') %}
shinken-{{ role }}-dead:
  service:
    - dead
    - name: shinken-{{ role }}

shinken-{{ role }}:
  service:
    - running
    - require:
      - cmd: shinken-killall
        {% endif -%}
    {%- endfor %}

shinken-killall:
  cmd:
    - run
    - name: killall -9 /usr/local/shinken/bin/python || /bin/true
    - require:
    {%- for role in roles -%}
        {%- if salt['file.file_exists']('/etc/init/shinken-' + role + '.conf') %}
      - service: shinken-{{ role }}-dead
        {% endif -%}
    {%- endfor -%}
{%- endif -%}
