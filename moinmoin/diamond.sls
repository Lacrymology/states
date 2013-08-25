{#
 Diamond statistics for moinmoin
#}
include:
  - diamond
  - rsyslog.diamond
  - nginx.diamond
  - uwsgi.diamond

uwsgi_diamond_moinmoin_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi.moinmoin]]
        cmdline = ^moinmoin-(worker|master)$
