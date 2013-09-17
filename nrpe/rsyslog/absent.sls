{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove rsyslog configuration for Nagios NRPE
-#}
/etc/rsyslog.d/nrpe.conf:
  file:
    - absent
