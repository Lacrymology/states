{#
 Diamond statistics for Salt API
#}
include:
  - diamond
  - salt.master.diamond
  - nginx.diamond
  - gsyslog.diamond

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
        cmdline = ^\/usr\/bin\/python \/usr\/bin\/salt\-api$
