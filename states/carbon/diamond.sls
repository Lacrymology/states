{#
 Diamond statistics for Carbon
#}
include:
  - diamond

diamond-carbon:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[carbon]]
        cmdline = ^\/usr\/local\/graphite\/bin\/python \/usr\/local\/graphite\/bin\/carbon\-cache\.py.+start$
