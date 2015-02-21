{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

backup-gitlab:
  file:
    - absent
    - name: /etc/cron.daily/backup-gitlab
