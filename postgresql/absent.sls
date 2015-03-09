{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "os.jinja2" import os with context %}

{%- if os.is_precise %}
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
{%- endif %}

postgresql-common:
  pkg:
    - purged

postgres:
  user:
    - absent
    - require:
      - pkg: postgresql-common
