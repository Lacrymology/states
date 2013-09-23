{#
 Undo moinmoin.backup state
 #}
/etc/cron.daily/backup-moinmoin:
  file:
    - absent
