{#
 Remove Nagios NRPE check for redis
#}
/etc/nagios/nrpe.d/redis.cfg:
  file:
    - absent
