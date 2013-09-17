{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for ProFTPd
-#}
/etc/nagios/nrpe.d/proftpd.cfg:
  file:
    - absent
