{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
pgbouncer:
  service:
    - dead
    - enable: False
  pkg:
    - purged
    - require:
      - service: pgbouncer
  file:
    - absent
    - name: /etc/pgbouncer
    - require:
      - pkg: pgbouncer
