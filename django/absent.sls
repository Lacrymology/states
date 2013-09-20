{#-
Author: Bruno Clermont patate@fastmail.cn
Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Django specifics
-#}
/usr/local/bin/check_robots.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_robots.py:
  file:
    - absent

/var/lib/nrpe:
  file:
    - absent
