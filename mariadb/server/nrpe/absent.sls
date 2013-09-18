{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE checks for MariaDB
-#}
/etc/nagios/nrpe.d/mysql.cfg:
  file:
    - absent
