{#-
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

backup-client:
  ssh_known_hosts:
    - present
    - name: {{ pillar['backup_server']['address'] }}
    - user: root
    - fingerprint: {{ pillar['backup_server']['fingerprint'] }}
