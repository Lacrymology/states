{#
 Remove Nagios NRPE check for OpenLDAP
#}
/etc/nagios/nrpe.d/openldap.cfg:
  file:
    - absent
