{#
 Remove Nagios NRPE check for bigbluebutton
#}
/etc/nagios/nrpe.d/bigbluebutton.cfg:
  file:
    - absent
