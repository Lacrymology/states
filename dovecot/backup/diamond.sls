{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - backup.diamond
  - cron.diamond

dovecot_backup_diamond_resources:
  file:
    - accumulated
    - name: processes
    - template: jinja
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[backup-dovecot-file]]
        cmdline = ^\/usr\/local\/bin\/backup-file dovecot
