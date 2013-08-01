{#
 Remove Nagios NRPE check for StatsD
#}
/etc/nagios/nrpe.d/statsd.cfg:
  file:
    - absent
