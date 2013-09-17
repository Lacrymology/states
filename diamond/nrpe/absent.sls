{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE checks for diamond
-#}
/etc/nagios/nrpe.d/diamond.cfg:
  file:
    - absent
