{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

backup-djangopypi2:
  file:
    - absent
    - name: /etc/cron.daily/backup-djangopypi2
