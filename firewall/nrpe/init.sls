{#
 Nagios NRPE check for iptables
#}
include:
  - nrpe
  - sudo

{#
 this is a constant used to define the -c flag of nagios check that set the
 maximal number of iptables rules before it's considered critical.
 the number is high because we only care about 0 iptables, where there is just
 no rules applied.
 #}
{% set critical=300 %}

/etc/sudoers.d/nrpe_firewall:
  file:
    - managed
    - template: jinja
    - source: salt://firewall/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - module: nrpe-virtualenv
      - pkg: sudo

/usr/local/bin/check_firewall.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_firewall.py:
  file:
    - managed
    - source: salt://firewall/nrpe/check.py
    - mode: 550
    - user: root
    - group: root
    - require:
      - module: nrpe-virtualenv
      - file: /etc/sudoers.d/nrpe_firewall
      - pkg: nagios-nrpe-server

/etc/nagios/nrpe.d/firewall.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://firewall/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      critical: {{ critical }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/firewall.cfg
