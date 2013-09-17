{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for StatsD
-#}
/etc/nagios/nrpe.d/statsd.cfg:
  file:
    - absent
