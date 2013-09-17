{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for MongoDB
-#}
/etc/nagios/nrpe.d/mongodb.cfg:
  file:
    - absent
