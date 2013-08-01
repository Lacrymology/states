{#
 Diamond statistics for Roundcube
#}
include:
  - diamond
  - nginx.diamond
  - uwsgi.diamond
  - rsyslog.diamond
  - postgresql.server.diamond

roundcube_web_diamond_resource:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi.roundcube]]
        cmdline = ^roundcube-(worker|master)$
