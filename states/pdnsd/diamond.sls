{#
 Diamond statistics for PDNSD
#}
include:
  - diamond

pdsnd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[pdnsd]]
        exe = ^\/usr\/sbin\/pdnsd$
