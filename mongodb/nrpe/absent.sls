{#
 Remove Nagios NRPE check for MongoDB
#}
/etc/nagios/nrpe.d/mongodb.cfg:
  file:
    - absent
