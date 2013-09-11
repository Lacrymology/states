{#-
Remove Nagios NRPE check for OpenERP
#}

/etc/nagios/nrpe.d/openerp.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-openerp.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/openerp-nginx.cfg:
  file:
    - absent
