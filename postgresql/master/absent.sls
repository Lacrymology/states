{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - postgresql.server.absent

/etc/postgresql/9.2/main/pg_hba.conf:
  file:
    - absent
    - require:
      - service: postgresql
