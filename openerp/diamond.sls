{#
 Diamond statistics for OpenERP
#}

include:
  - diamond
  - nginx.diamond
  - postgresql.server.diamond

openerp_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[openerp]]
        exe = ^\/usr\/bin\/openerp\-server$

