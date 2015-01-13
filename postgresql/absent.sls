{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
/etc/apt/sources.list.d/postgresql.list:
  file:
    - absent

apt-key del 8683D8A2:
  cmd:
    - run
    - onlyif: apt-key list | grep -q 8683D8A2

postgresql-dev:
{#-
  Can't uninstall the following as they're used elsewhere
  pkg:
    - purged
    - name: libpq-dev
#}
  pkgrepo:
    - absent
    - ppa: pitti/postgresql
  file:
    - absent
    - name: /etc/apt/sources.list.d/pitti-postgresql-{{ grains['oscodename'] }}.list
    - require:
      - pkgrepo: postgresql-dev
