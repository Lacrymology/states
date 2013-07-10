{#
 Undo postgresql state
#}
libpq-dev:
  pkg:
    - purged

/etc/apt/sources.list.d/pitti-postgresql-precise.list:
  file:
    - absent

apt-key del 8683D8A2:
  cmd:
    - run
    - onlyif: apt-key list | grep -q 8683D8A2
