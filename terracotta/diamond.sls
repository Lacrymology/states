{#
 Diamond statistics for terracotta
#}

include:
  - diamond

terracotta_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[terracotta]]
        cmdline = java \-server.+\-cp.+\/lib\/tc\.jar
