{#
 Nagios NRPE check for OpenVPN
#}
include:
  - nrpe

/etc/nagios/nrpe.d/openvpn.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://openvpn/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      instances: {{ pillar['openvpn']|default({}) }}

extend:
  diamond:
    service:
      - watch:
        - file: openvpn_diamond_collector
