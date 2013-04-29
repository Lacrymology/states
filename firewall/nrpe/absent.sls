{#
 Remove Nagios NRPE check for iptables
#}
{% if 'shinken_pollers' in pillar %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/firewall.cfg
{% endif %}

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
