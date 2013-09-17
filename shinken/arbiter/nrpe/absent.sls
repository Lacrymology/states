{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for Shinken arbiter
-#}
/etc/nagios/nrpe.d/shinken-arbiter.cfg:
  file:
    - absent
