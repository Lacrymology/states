{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Dang Tung Lam <lam@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}

ejabberd:
  pkg:
    - purged
    - require:
      - service: ejabberd
  service:
    - dead
  cmd:
    - wait
    - name: epmd -kill
    - watch:
      - pkg: ejabberd
  user:
    - absent
    - require:
      - pkg: ejabberd
      - cmd: ejabberd
  group:
    - absent
    - require:
      - user: ejabberd

{%- for file in ('/var/lib/ejabberd', '/etc/ejabberd', '/var/log/ejabberd', '/usr/lib/ejabberd') %}
{{ file }}:
  file:
    - absent
    - name: {{ file }}
    - require:
      - pkg: ejabberd
{%- endfor %}

ejabberd-backups:
  cmd:
    - wait
    - name: rm -rf /var/backups/ejabberd-*
    - watch:
      - pkg: ejabberd
