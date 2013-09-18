{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for terracotta
-#}
/etc/nagios/nrpe.d/terracotta.cfg:
  file:
    - absent
