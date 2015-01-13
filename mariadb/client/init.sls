{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt
  - mariadb

mysql-client:
  pkg:
    - installed
    - name: mariadb-client
    - require:
      - cmd: apt_sources
      - pkgrepo: mariadb
      - pkg: mariadb
