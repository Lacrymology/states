{#
 Diamond statistics for amavis
#}

include:
  - diamond

amavis_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[amavis]]
        name = ^amavisd\ \(master\)
