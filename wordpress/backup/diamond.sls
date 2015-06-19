{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.diamond
  - cron.diamond

wordpress_backup_diamond_resources:
  file:
    - accumulated
    - name: processes
    - template: jinja
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[backup-wordpress-file]]
        cmdline = ^\/usr\/local\/bin\/backup-file wordpress
        [[backup-wordpress-mysql]]
        cmdline = ^\/usr\/local\/bin\/backup-mysql {{ salt['pillar.get']('wordpress:db:name', 'wordpress') }}$
