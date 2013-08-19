{#
 Remove Nagios NRPE check for Salt-API Server
#}
/etc/nagios/nrpe.d/salt-api.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/salt-api-nginx.cfg:
  file:
    - absent
