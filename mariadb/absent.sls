{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
