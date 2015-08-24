{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.diamond
  - cron.diamond

piwik_backup_diamond_resources:
  file:
    - accumulated
    - name: processes
    - template: jinja
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[backup-piwik-file]]
        cmdline = ^\/usr\/local\/bin\/backup-file piwik \/etc piwik$
        [[backup-piwik-mysql]]
        cmdline = ^\/usr\/local\/bin\/backup-file piwik \/etc piwik$
