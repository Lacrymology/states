{#
 Diamond statistics for wordpress
#}
include:
  - diamond
  - nginx.diamond
  - uwsgi.diamond
  - mariadb.server.diamond

wordpress_web_diamond_resource:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi.wordpress]]
        cmdline = ^wordpress-(worker|master)$
