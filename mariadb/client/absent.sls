{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
mysql-client:
  pkg:
    - purged
    - pkgs:
      - mariadb-client
      - mariadb-client-5.5
