{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Poor man backup client NRPE check
 -#}
include:
  - backup.absent

{% if salt['pillar.get']('backup_server:address', False) %}
backup-client:
  ssh_known_hosts:
    - absent
    - name: {{ pillar['backup_server']['address'] }}
    - user: root
    - fingerprint: {{ pillar['backup_server']['fingerprint'] }}
    - order: 1
{% endif %}
