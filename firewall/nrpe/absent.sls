{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for iptables
-#}
/etc/sudoers.d/nrpe_firewall:
  file:
    - absent

/usr/local/bin/check_firewall.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_firewall.py:
  file:
    - absent

/etc/nagios/nrpe.d/firewall.cfg:
  file:
    - absent
