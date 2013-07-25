{#
 Remove Nagios NRPE check for Nginx
#}
/etc/nagios/nrpe.d/nginx.cfg:
  file:
    - absent
