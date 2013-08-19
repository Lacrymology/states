{#
 Remove Nagios NRPE check for Salt Master
 #}
/etc/nagios/nrpe.d/salt-master.cfg:
  file:
    - absent
