{#
 Remove Nagios NRPE check for Tightvncserver
#}

/etc/nagios/nrpe.d/tightvncserver.cfg:
  file:
    - absent
