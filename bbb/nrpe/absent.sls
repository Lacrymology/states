{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for bigbluebutton
-#}
/etc/nagios/nrpe.d/bigbluebutton.cfg:
  file:
    - absent
