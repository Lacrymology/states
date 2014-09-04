{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

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
