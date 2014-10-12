include:
  - mariadb.server.backup

test_backup_mysql:
  cmd:
    - run
    - name: /usr/local/bin/backup-mysql-all
    - require:
      - file: /usr/local/bin/backup-mysql-all
