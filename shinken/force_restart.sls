{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>

Sometimes some processes get crazy (most of the time, the reactionner)
and it need to be manually kill. This state force a restart.
-#}

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
