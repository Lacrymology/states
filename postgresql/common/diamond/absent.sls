{#- Usage of this is governed by a license that can be found in doc/license.rst
-*- ci-automatic-discovery: off -*-
-#}
{{ opts['cachedir'] }}/pip/postgresql.common.diamond:
  file:
    - absent

postgresql_diamond_collector:
  file:
    - name: /etc/diamond/collectors/PostgresqlCollector.conf
    - absent
