{#
 Diamond statistics for Salt API
#}
include:
  - diamond

salt_api_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[salt.api]]
        cmdline = ^python \/usr\/bin\/salt\-api$
