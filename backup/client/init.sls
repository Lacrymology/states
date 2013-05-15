{#
 Poor man backup using rsync and scp
 #}

include:
  - ssh.client

backup-client:
  ssh_known_hosts:
    - present
    - name: {{ pillar['backup_server']['address'] }}
    - user: root
    - fingerprint: {{ pillar['backup_server']['fingerprint'] }}
