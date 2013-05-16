{#
 Diamond statistics for Salt Master
#}
include:
  - diamond
  - gsyslog.diamond

salt_master_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[salt.master]]
        cmdline = ^python \/usr\/bin\/salt\-master$
