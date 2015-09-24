{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{% from "postgresql/map.jinja2" import postgresql with context %}
{% set version = postgresql.version %}
include:
  - postgresql.server.absent
