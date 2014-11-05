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

Uninstall a Salt Management Master (server).
-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
include:
  - salt.api.absent

{{ upstart_absent('salt-master') }}

extend:
  salt-master:
{#- Workaround bug that sometime salt-master process doesn't stop after integration.py cleanup phase #}
    cmd:
      - run
      - onlyif: pgrep salt-master
      - name: kill -9 `pgrep salt-master` || true
      - require:
        - pkg: salt-master
    pkg:
      - purged
      - require:
        - service: salt-master

{#-
{% if salt['cmd.has_exec']('pip') %}
GitPython:
  pip:
    - removed
{% endif %}
-#}

{%- for file in ('pillars', 'salt') %}
/srv/{{ file }}:
  file:
    - absent
    - require:
      - pkg: salt-master
{% endfor %}

salt-master-job_changes.py:
  file:
    - absent
    - name: /usr/local/bin/salt-master-job_changes.py

salt-master-requirements:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/salt.master

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/salt-master-requirements.txt:
  file:
    - absent

/var/cache/salt/master:
  file:
    - absent
    - require:
      - pkg: salt-master

/etc/salt/master.d:
  file:
    - absent
    - require:
      - pkg: salt-master
