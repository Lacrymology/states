{#
 Remove Nagios NRPE check for terracotta
#}
/etc/nagios/nrpe.d/terracotta.cfg:
  file:
    - absent
