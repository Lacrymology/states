{#
 Remove Nagios NRPE check for NTP
#}
/etc/nagios/nrpe.d/ntpd.cfg:
  file:
    - absent
