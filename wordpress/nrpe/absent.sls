{#
 Remove Wordpress Nagios NRPE checks
#}
/etc/nagios/nrpe.d/wordpress.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/wordpress-nginx.cfg:
  file:
    - absent

