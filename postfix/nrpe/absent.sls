{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com

 Remove Nagios NRPE check for Postfix
-#}
/etc/nagios/nrpe.d/postfix.cfg:
  file:
    - absent
