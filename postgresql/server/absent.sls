{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Uninstall a PostgreSQL database server.
 -#}
{% set version="9.2" %}

postgresql:
  pkg:
{% if pillar['destructive_absent']|default(False) %}
    - purged
{% else %}
    - removed
{% endif %}
    - pkgs:
      - postgresql-{{ version }}
      - postgresql-client-{{ version }}
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
