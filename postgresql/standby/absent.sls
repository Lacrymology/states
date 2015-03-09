{#- Usage of this is governed by a license that can be found in doc/license.rst
-*- ci-automatic-discovery: off -*-

-#}

{% from "postgresql/map.jinja2" import postgresql with context %}
{% set version = postgresql.version %}

include:
  - postgresql.server.absent

/var/lib/postgresql/{{ version }}/main/recovery.conf:
  file:
    - absent
    - require:
      - service: postgresql
