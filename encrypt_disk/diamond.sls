{#- Usage of this is governed by a license that can be found in doc/license.rst #}
include:
  - diamond

{#-
DiskusageCollector from diamond formula read from all mount points, no
config is needed.
#}

{#- salt can't require sls with no state #}
encrypt_disk_diamond:
  cmd:
    - wait
    - name: /bin/echo 'this state does nothing'
