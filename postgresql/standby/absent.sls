include:
  - postgresql.server.absent

{% set version="9.2" %}

/var/lib/postgresql/{{ version }}/main/recovery.conf:
  file:
    - absent
    - require:
      - service: postgresql
