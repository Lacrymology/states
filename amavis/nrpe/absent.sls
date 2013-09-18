{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for Amavis
-#}
/etc/nagios/nrpe.d/amavis.cfg:
  file:
    - absent
