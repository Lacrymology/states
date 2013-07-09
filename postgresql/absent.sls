{#
 Undo postgresql state
#}
libpq-dev:
  pkg:
    - purged

/etc/apt/sources.list.d/pitti-postgresql-precise.list:
  file:
    - absent
