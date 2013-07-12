{#
 Remove gsyslog configuration for iptables
#}
/etc/gsyslog.d/firewall.conf:
  file:
    - absent
