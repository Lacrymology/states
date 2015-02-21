{#- Usage of this is governed by a license that can be found in doc/license.rst
-*- ci-automatic-discovery: off -*-

-#}

{%- from "postgresql/init.sls" import postgresql_version with context -%}

include:
  - postgresql.server.absent

/var/lib/postgresql/{{ postgresql_version() }}/main/recovery.conf:
  file:
    - absent
    - require:
      - service: postgresql