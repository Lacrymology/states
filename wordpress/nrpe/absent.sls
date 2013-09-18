{#-
 Author: Lam Dang Tung lamdt@familug.org
 Maintainer: Lam Dang Tung lamdt@familug.org
 
 Remove Wordpress Nagios NRPE checks
-#}
/etc/nagios/nrpe.d/wordpress.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/wordpress-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/wordpress-mysql.cfg:
  file:
    - absent
