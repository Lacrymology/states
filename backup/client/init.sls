{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.client.{{ salt['pillar.get']('backup_storage') }}
