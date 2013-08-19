{#
 Diamond statistics for rsyslog
#}
include:
  - diamond

rsyslog_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[rsyslog]]
        exe = ^rsyslogd
