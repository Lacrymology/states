{#-
Remove Nagios NRPE check for OpenERP
#}

/etc/nagios/nrpe.d/openerp-server.cfg:
  file:
    - absent
