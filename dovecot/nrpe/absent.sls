{#
 Remove Nagios NRPE check for Dovecot
#}
/etc/nagios/nrpe.d/dovecot.cfg:
  file:
    - absent
