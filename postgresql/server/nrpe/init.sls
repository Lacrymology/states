{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{% set ssl = salt['pillar.get']('postgresql:ssl', False) %}
include:
  - apt.nrpe
  - nrpe
  - postgresql.common.nrpe
  - postgresql.nrpe
  - postgresql.server
  - rsyslog.nrpe
{% if ssl %}
  - ssl.nrpe
{% endif %}

extend:
  postgresql_monitoring:
    postgres_user:
      - require:
        - service: postgresql
