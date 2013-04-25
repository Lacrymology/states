{#
 Diamond statistics for NodeJS
#}
include:
  - diamond

nodejs_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[nodejs]]
        exe = ^\/usr\/bin\/nodejs
