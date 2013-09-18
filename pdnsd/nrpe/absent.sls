{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove pDNSd Nagios NRPE checks
 -#}
/etc/nagios/nrpe.d/pdnsd.cfg:
  file:
    - absent
