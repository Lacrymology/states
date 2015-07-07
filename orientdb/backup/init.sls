include:
  - bash
  - backup.client.{{ salt['pillar.get']('backup_storage') }}
  - cron
  - orientdb

/var/backups/orientdb:
  file:
    - directory
    - user: orientdb
    - group: orientdb
    - mode: 770
    - require:
      - user: orientdb
    - require_in:
      - service: orientdb

backup-orientdb:
  file:
    - managed
    - name: /etc/cron.daily/backup-orientdb
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://orientdb/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-store
      - file: bash
      - file: /var/backups/orientdb

extend:
  /etc/orientdb/config.xml:
    file:
      - context:
          debug: {{ salt['pillar.get']('orientdb:debug', False) }}
          backup: True
          cluster: {{ salt['pillar.get']('orientdb:cluster', {}) }}