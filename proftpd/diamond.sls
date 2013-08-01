{#
 Diamond statistics for ProFTPd
#}
include:
  - diamond
  - postgresql.server.diamond
  - rsyslog.diamond

proftpd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[proftpd]]
        exe = ^\/usr\/sbin\/proftpd$
