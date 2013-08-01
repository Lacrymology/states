{#
 Remove rsyslog configuration for iptables
#}
/etc/rsyslog.d/firewall.conf:
  file:
    - absent
