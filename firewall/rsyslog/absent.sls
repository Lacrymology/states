{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove rsyslog configuration for iptables
-#}
/etc/rsyslog.d/firewall.conf:
  file:
    - absent
