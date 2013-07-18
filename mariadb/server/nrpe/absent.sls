{#-
 Remove Nagios NRPE checks for MariaDB
#}
/etc/nagios/nrpe.d/mysql.cfg:
  file:
    - absent
