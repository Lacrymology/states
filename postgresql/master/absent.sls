{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "postgresql/init.sls" import postgresql_version with context -%}
include:
  - postgresql.server.absent

/etc/postgresql/{{ postgresql_version() }}/main/pg_hba.conf:
  file:
    - absent
    - require:
      - service: postgresql
