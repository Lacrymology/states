{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for Rsync
-#}
/etc/nagios/nrpe.d/rsync.cfg:
  file:
    - absent
