{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for Carbon
-#}
/etc/nagios/nrpe.d/carbon.cfg:
  file:
    - absent
