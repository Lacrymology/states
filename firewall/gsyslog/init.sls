{#
 Gsyslog configuration for iptables
#}
include:
  - gsyslog

{#
 this is a constant used to define the -c flag of nagios check that set the
 maximal number of iptables rules before it's considered critical.
 the number is high because we only care about 0 iptables, where there is just
 no rules applied.
 #}
{% set critical=300 %}

/etc/gsyslog.d/firewall.conf:
  file:
    - managed
    - source: salt://firewall/gsyslog/config.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: root
    - context:
      critical: {{ critical }}
    - require:
      - file: /etc/gsyslog.d

extend:
  gsyslog:
    service:
      - watch:
        - file: /etc/gsyslog.d/firewall.conf
