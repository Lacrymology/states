{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
/etc/apt/sources.list.d/mariadb.list:
  file:
    - absent

mariadb_remove_key:
  cmd:
    - run
    - name: 'apt-key del 0xcbcb082a1bb943db'
    - onlyif: apt-key list | grep -q 0xcbcb082a1bb943db

mariadb:
  pkgrepo:
    - absent
  file:
    - absent
    - name: /etc/apt/sources.list.d/l-mierzwa-lucid-php5-{{ grains['oscodename'] }}.list
    - require:
      - pkgrepo: mariadb
