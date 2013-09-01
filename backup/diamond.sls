{#
 Diamond statistics for backup client
#}
include:
  - diamond

backup_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[backup]]
        cmdline = ^\/usr\/local\/bin\/backup_store$
