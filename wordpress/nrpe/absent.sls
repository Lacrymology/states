{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/nagios/nrpe.d/wordpress.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/wordpress-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/wordpress-mysql.cfg:
  file:
    - absent

/etc/cron.d/passive-checks-wordpress:
  file:
    - absent
