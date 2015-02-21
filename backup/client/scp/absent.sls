{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.absent
  - backup.client.absent

{#- Can't run this in absent as ssh-keygen might not be there to be executed
 if salt['pillar.get']('backup_server:address', False)
backup-client:
  ssh_known_hosts:
    - absent
    - name: {{ salt['pillar.get']('backup_server:address') }}
    - order: 1
 endif
 #}
