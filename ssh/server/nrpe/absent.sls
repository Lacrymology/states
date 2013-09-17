{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for OpenSSH Server
-#}
/etc/nagios/nrpe.d/ssh.cfg:
  file:
    - absent
