{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for Dovecot
-#}
/etc/nagios/nrpe.d/dovecot.cfg:
  file:
    - absent
