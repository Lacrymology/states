{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Nagios NRPE check for uWSGI
-#}
/etc/nagios/nrpe.d/uwsgi.cfg:
  file:
    - absent

/etc/sudoers.d/nagios_uwsgi:
  file:
    - absent

/etc/sudoers.d/nrpe_uwsgi:
  file:
    - absent

/usr/local/bin/uwsgi-nagios.sh:
  file:
   - absent

/usr/lib/nagios/plugins/check_uwsgi:
  file:
    - absent
