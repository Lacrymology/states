{#
 Diamond statistics for StatsD
#}
include:
  - diamond
  - gsyslog.diamond

statsd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[statsd]]
        cmdline = ^\/usr\/local\/statsd\/bin\/python \/usr\/local\/statsd\/bin\/pystatsd\-server
