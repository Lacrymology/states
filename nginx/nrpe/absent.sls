{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for Nginx
-#}
/etc/nagios/nrpe.d/nginx.cfg:
  file:
    - absent
