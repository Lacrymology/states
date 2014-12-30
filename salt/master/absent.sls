{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

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
