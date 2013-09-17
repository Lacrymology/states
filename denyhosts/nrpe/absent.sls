{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn

 Remove Nagios NRPE check for Denyhosts
-#}

/etc/nagios/nrpe.d/denyhosts.cfg:
  file:
    - absent

/var/lib/denyhosts/allowed-hosts:
  file:
    - absent
