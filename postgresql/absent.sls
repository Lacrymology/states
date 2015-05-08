{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/apt/sources.list.d/postgresql.list:
  file:
    - absent

/etc/apt/trusted.gpg.d/apt.postgresql.org.gpg~:
  file:
    - absent
    - require:
      - cmd: postgresql-9.4-apt-key

postgresql-9.2-apt-key:
  cmd:
    - run
    - name: apt-key del 8683D8A2
    - onlyif: apt-key list | grep -q 8683D8A2

postgresql-9.4-apt-key:
  cmd:
    - run
    - name: apt-key del ACCC4CF8
    - onlyif: apt-key list | grep -q ACCC4CF8

{#-
  Can't uninstall the following as they're used elsewhere
  pkg:
postgresql-dev:
    - purged
    - name: libpq-dev
#}

postgresql-common:
  pkg:
    - purged

postgres:
  user:
    - absent
    - require:
      - pkg: postgresql-common
