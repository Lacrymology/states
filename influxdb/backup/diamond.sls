include:
  - diamond
  - cron.diamond
  - backup.diamond

influxdb_backup_diamond_resources:
  file:
    - accumulated
    - name: processes
    - template: jinja
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[backup-influxdb]]
        cmdline = ^/usr/local/bin/backup-file influxdb /var/lib/influxdb/backup
