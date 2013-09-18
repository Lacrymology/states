{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for ClamAV
-#}
/etc/nagios/nrpe.d/clamav.cfg:
  file:
    - absent
