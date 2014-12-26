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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

This state is the most simple way to upgrade to restart a minion.
It don't requires on any other state (sls) file except salt
(for the repository).

It's kept at the minion to make sure it don't change anything else during the
upgrade process.
-#}

include:
  - apt
  - salt

/etc/salt/minion:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://salt/minion/config.jinja2
    - require_in:
      - pkg: salt-minion

salt-minion:
  file:
    - managed
    - name: /etc/init/salt-minion.conf
    - template: jinja
    - source: salt://salt/minion/upstart.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: salt-minion
  pkg:
    - latest
  service:
    - running
    - enable: True
    - skip_verify: True
    - require:
      - file: /var/cache/salt
    - watch:
      - pkg: salt-minion
      - file: /etc/salt/minion
      - file: salt-minion
      - cmd: salt

/etc/salt/minion.d:
  file:
    - directory
    - user: root
    - group: root
    - mode: 750
    - require_in:
      - pkg: salt-minion
    - watch_in:
      - service: salt-minion

{%- for file in ('logging', 'graphite', 'mysql') %}
  {%- if (file == 'graphite' and salt['pillar.get']('graphite_address', False)) or file != 'graphite' %}
/etc/salt/minion.d/{{ file }}.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/minion/{{ file }}.jinja2
    - require:
      - file: /etc/salt/minion.d
    - require_in:
      - pkg: salt-minion
    - watch_in:
      - service: salt-minion
  {%- endif %}
{%- endfor %}
