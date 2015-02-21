{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "postgresql/init.sls" import postgresql_version with context -%}
{%- set version = postgresql_version() %}

postgresql:
  pkg:
    - purged
    - pkgs:
      - postgresql-client-common
    - require:
      - service: postgresql
  file:
    - absent
    - name: /etc/postgresql/{{ version }}
    - require:
      - pkg: postgresql
  service:
    - dead
    - enable: False

/etc/logrotate.d/postgresql-common:
  file:
    - absent

/var/log/postgresql/postgresql-{{ version }}-main.log:
  file:
    - absent
