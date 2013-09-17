{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for OpenVPN
-#}
/etc/nagios/nrpe.d/openvpn.cfg:
  file:
    - absent
