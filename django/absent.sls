{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/usr/local/bin/check_robots.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_robots.py:
  file:
    - absent

/var/lib/nrpe:
  file:
    - absent
