include:
  - backup.server

backup-archiver:
  cmd:
    - run
    - name: /etc/cron.weekly/backup-archiver
    - require:
      - file: /etc/cron.weekly/backup-archiver
