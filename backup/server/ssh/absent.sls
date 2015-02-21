{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

cleanup-old-archive:
  file:
    - absent
    - name: /etc/cron.daily/backup-server-ssh

/etc/cron.daily/cleanup-old-archive:
  file:
    - absent
