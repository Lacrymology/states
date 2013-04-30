{#
 Undo sentry.backup state
 #}
/etc/cron.daily/backup-sentry:
  file:
    - absent
