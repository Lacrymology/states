{#
 Diamond statistics for Denyhosts
 #}
include:
  - diamond

denyhosts_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[denyhosts]]
        cmdline = ^python \/usr\/sbin\/denyhosts
