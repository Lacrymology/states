{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for rsyslog
-#}
/etc/nagios/nrpe.d/rsyslog.cfg:
  file:
    - absent
