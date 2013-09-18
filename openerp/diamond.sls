{#-
 Author: Lam Dang Tung lamdt@familug.org
 Maintainer: Lam Dang Tung lamdt@familug.org
 
 Diamond statistics for OpenERP
-#}

include:
  - diamond
  - nginx.diamond
  - postgresql.server.diamond
  - uwsgi.diamond

openerp_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi.openerp]]
        cmdline = ^openerp-(worker|master)$

