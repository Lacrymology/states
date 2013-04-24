{#
 Diamond statistics for SSMTP
#}
include:
  - diamond

ssmtp_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[ssmtp]]
        exe = ^\/usr\/sbin\/ssmtp$
