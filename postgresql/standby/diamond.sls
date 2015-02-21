{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
-*- ci-automatic-discovery: off -*-
-#}

include:
  - postgresql.common.diamond
  - postgresql.server.diamond
  - postgresql.standby

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
