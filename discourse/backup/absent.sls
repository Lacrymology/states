{#-
 Author: Lam Dang Tung lamdt@familug.org
 Maintainer: Lam Dang Tung lamdt@familug.org
 
  Remove backup Discourse
-#}
/etc/cron.daily/backup-discourse:
  file:
    - absent
