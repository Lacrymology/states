{#-
Remove Nagios NRPE check for OpenERP
#}

/etc/nagios/nrpe.d/openerp-server.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-openerp.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/roundcube-nginx.cfg:
  file:
    - absent
