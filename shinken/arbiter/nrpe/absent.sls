{#
 Remove Nagios NRPE check for Shinken arbiter
#}
/etc/nagios/nrpe.d/shinken-arbiter.cfg:
  file:
    - absent
