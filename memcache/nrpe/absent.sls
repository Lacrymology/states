{#
 Remove Nagios NRPE check for Memcache
#}
/etc/nagios/nrpe.d/memcache.cfg:
  file:
    - absent
