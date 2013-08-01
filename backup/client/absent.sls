{#
 Remove Poor man backup client NRPE check
 #}

{% if salt['pillar.get']('backup_server:address', False) %}
backup-client:
  ssh_known_hosts:
    - absent
    - name: {{ pillar['backup_server']['address'] }}
    - user: root
    - fingerprint: {{ pillar['backup_server']['fingerprint'] }}
    - order: 1
{% endif %}
