{#
 Remove Nagios NRPE check for Postfix
#}
/etc/nagios/nrpe.d/postfix.cfg:
  file:
    - absent
