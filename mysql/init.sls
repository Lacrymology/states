{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - hostname

{%- set files_archive = salt['pillar.get']('files_archive', False) %}

mysql-common:
  pkg:
    - latest

mysql:
  pkg:
    - installed
    - name: libmysqlclient18
    - require:
      - host: hostname
      - pkg: mysql-common
