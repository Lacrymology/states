{#-
 Sometimes some processes get crazy (most of the time, the reactionner)
 and it need to be manually kill. This state force a restart.
 -#}

{%- set roles = ('broker', 'arbiter', 'reactionner', 'poller', 'scheduler') -%}

{%- for role in roles -%}
    {%- if salt['file.file_exists']('/etc/init/shinken-' + role + '.conf') %}
shinken-{{ role }}-dead:
  service:
    - dead

shinken-{{ role }}:
  service:
    - running
    - require:
      - cmd: shinken-killall
    {% endif -%}
{%- endfor -%}

shinken-killall:
  cmd:
    - run
    - name: killall -9 /usr/local/shinken/bin/python
    - require:
{%- for role in roles -%}
    {%- if salt['file.file_exists']('/etc/init/shinken-' + role + '.conf') %}
      - service: shinken-{{ role }}-dead
    {% endif -%}
{%- endfor -%}
