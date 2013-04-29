{#
 Remove gsyslog configuration for iptables
#}
include:
  - gsyslog

/etc/gsyslog.d/firewall.conf:
  file:
    - absent

extend:
  gsyslog:
    service:
      - watch:
        - file: /etc/gsyslog.d/firewall.conf
