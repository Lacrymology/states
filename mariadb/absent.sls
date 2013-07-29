/etc/apt/sources.list.d/mariadb.list:
  file:
    - absent

mariadb_remove_key:
  cmd:
    - run
    - name: 'apt-key del 0xcbcb082a1bb943db'
    - onlyif: apt-key list | grep -q 0xcbcb082a1bb943db
