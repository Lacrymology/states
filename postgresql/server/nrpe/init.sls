{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
