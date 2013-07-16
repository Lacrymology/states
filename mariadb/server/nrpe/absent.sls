{#
 Remove Nagios NRPE checks for mariadb
#}
/etc/nagios/nrpe.d/mysql.cfg:
  file:
    - absent
