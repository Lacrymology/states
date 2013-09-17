{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for NTP
-#}
/etc/nagios/nrpe.d/ntpd.cfg:
  file:
    - absent
