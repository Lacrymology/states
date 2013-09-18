{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for PostgreSQL Server
-#}
/etc/nagios/nrpe.d/postgresql-diamond.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql.cfg:
  file:
    - absent
