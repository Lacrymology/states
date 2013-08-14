include:
  - s3cmd

/usr/local/bin/backup_store:
	file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://backup/s3/backup_store.jinja
    - require:
      - pkg: s3cmd
