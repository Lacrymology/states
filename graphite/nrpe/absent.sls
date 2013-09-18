{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Nagios NRPE check for Graphite
-#}
/etc/nagios/nrpe.d/graphite.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/graphite-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-graphite.cfg:
  file:
    - absent
