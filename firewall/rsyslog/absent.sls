{#
 Remove rsyslog configuration for iptables
#}
include:
  - rsyslog

/etc/rsyslog.d/firewall.conf:
  file:
    - absent

extend:
  rsyslog:
    service:
      - watch:
        - file: /etc/rsyslog.d/firewall.conf
