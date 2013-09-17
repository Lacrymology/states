{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for Memcache
-#}
/etc/nagios/nrpe.d/memcache.cfg:
  file:
    - absent
