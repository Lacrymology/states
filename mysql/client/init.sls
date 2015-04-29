{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - mysql

mysql-client:
  pkg:
    - installed
    - name: mysql-client
    - require:
      - cmd: apt_sources
      - pkg: mysql
