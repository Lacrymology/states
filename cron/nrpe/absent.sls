{#
 Remove Nagios NRPE check for cron
#}
/etc/nagios/nrpe.d/cron.cfg:
  file:
    - absent
