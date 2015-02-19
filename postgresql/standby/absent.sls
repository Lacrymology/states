{#-
-*- ci-automatic-discovery: off -*-

Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from "postgresql/init.sls" import postgresql_version with context -%}

include:
  - postgresql.server.absent

/var/lib/postgresql/{{ postgresql_version() }}/main/recovery.conf:
  file:
    - absent
    - require:
      - service: postgresql
