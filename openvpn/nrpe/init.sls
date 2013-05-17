{#
 Nagios NRPE check for OpenVPN
#}
include:
  - nrpe
  - apt.nrpe

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
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/openvpn.cfg
