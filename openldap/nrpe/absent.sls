{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for OpenLDAP
-#}
/etc/nagios/nrpe.d/openldap.cfg:
  file:
    - absent
