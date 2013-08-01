{#
 Remove Nagios NRPE check for Salt Minion
#}
/etc/nagios/nrpe.d/salt-minion.cfg:
  file:
    - absent
