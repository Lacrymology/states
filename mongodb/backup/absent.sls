{#
 Remove Backup client for MongoDB
 #}

/usr/local/bin/backup-mongodb:
  file:
    - absent

/usr/local/bin/backup-mongodb-copy:
  file:
    - absent

/usr/local/bin/backup-mongodb-all:
  file:
    - absent
