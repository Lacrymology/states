{#
 Diamond statistics for Gsyslog
#}
include:
  - diamond

gsyslog_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[gsyslog]]
        cmdline = ^\/usr\/local\/gsyslog\/bin\/python \/usr\/local\/gsyslog\/bin\/gsyslogd
        [[klogd]]
        exe = ^\/sbin\/klogd
