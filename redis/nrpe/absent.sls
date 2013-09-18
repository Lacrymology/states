{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for redis
-#}
/etc/nagios/nrpe.d/redis.cfg:
  file:
    - absent
