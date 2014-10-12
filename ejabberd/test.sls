{#- run backup #}

{# /etc/cron.d/sslyze_check_ #}
include:
  - ejabberd.backup

test_backup_ejabberd:
  cmd:
    - run
    - name: /etc/cron.daily/backup-ejabberd
    - require:
      - file: /etc/cron.daily/backup-ejabberd
