{#-
 Author: Nicolas Plessis nicolas@microsigns.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for jenkins
-#}
/etc/nagios/nrpe.d/jenkins-nginx.cfg:
  file:
    - absent
