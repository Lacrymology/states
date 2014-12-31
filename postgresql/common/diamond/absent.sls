{#-
-*- ci-automatic-discovery: off -*-

Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
/usr/local/diamond/salt-postgresql-requirements.txt:
  file:
    - absent

postgresql_diamond_collector:
  file:
    - name: /etc/diamond/collectors/PostgresqlCollector.conf
    - absent
