include:
  - openerp.backup

test_backup_openerp:
  cmd:
    - run
    - name: /etc/cron.daily/backup-openerp
    - require:
      - file: backup-openerp

{# /etc/cron.d/sslyze_check_ #}
