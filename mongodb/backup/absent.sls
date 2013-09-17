{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Backup client for MongoDB
 -#}

/usr/local/bin/backup-mongodb:
  file:
    - absent

/usr/local/bin/backup-mongodb-all:
  file:
    - absent
