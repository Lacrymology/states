{#-
 Author: Lam Dang Tung lamdt@familug.org
 Maintainer: Lam Dang Tung lamdt@familug.org
 
 Remove Backup for Gitlab
 -#}
/etc/cron.daily/backup-gitlab:
  file:
    - absent
