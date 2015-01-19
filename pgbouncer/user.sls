{#-
-*- ci-automatic-discovery: off -*-

Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- for db, values in salt['pillar.get']('pgbouncer:databases').iteritems() %}
pgbouncer_{{ db }}:
  postgres_user:
    - present
    - name: {{ values['username'] }}
    - password: {{ values['password'] }}
    - superuser: True
    - runas: postgres
  postgres_database:
    - present
    - name: {{ db }}
    - owner: {{ values['username'] }}
    - runas: postgres
    - require:
      - postgres_user: pgbouncer_{{ db }}
{%- endfor %}
