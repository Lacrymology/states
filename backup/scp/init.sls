{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
Backup Client
=============

Poor man backup using rsync and scp.

Mandatory Pillar
----------------

backup_server:
  address: 192.168.1.1
  fingerprint: 00:de:ad:be:ef:xx

backup_server:address: IP/Hostname of backup server.
backup_server:fingerprint: SSH fingerprint of backup SSH server.
-#}

include:
  - ssh.client
  - local

backup-client:
  ssh_known_hosts:
    - present
    - name: {{ pillar['backup_server']['address'] }}
    - user: root
    - fingerprint: {{ pillar['backup_server']['fingerprint'] }}

/usr/local/bin/backup_store:
  file:
    - managed
    - user: root
    - group: root
    - mode: 550
    - template: jinja
    - source: salt://backup/scp/copy.jinja2
    - require:
      - file: /usr/local
