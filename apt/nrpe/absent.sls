{#
 Remove Nagios NRPE check for APT
#}
/etc/nagios/nrpe.d/apt.cfg:
  file:
    - absent

/usr/local/bin/check_apt-rc.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_apt-rc.py:
  file:
    - absent
