{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Uninstall a PostgreSQL database server.
-#}
{% set version="9.2" %}

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
