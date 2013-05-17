{#
 Remove Nagios NRPE checks for diamond
#}
/etc/nagios/nrpe.d/diamond.cfg:
  file:
    - absent
