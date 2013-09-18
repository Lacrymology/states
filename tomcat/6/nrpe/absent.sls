{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for tomcat
-#}
/etc/nagios/nrpe.d/tomcat.cfg:
  file:
    - absent
