{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for cron
-#}
/etc/nagios/nrpe.d/cron.cfg:
  file:
    - absent
