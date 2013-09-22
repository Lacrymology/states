{#
 Remove Discourse NRPE checks
#}
/etc/nagios/nrpe.d/discourse.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/discourse-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-discourse.cfg:
  file:
    - absent


