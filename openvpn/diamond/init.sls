{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Diamond statistics for OpenVPN
-#}
include:
  - diamond

openvpn_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/OpenVPNCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://openvpn/diamond/config.jinja2
    - context:
      instances: {{ pillar['openvpn']|default({}) }}
    - require:
      - file: /etc/diamond/collectors

openvpn_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[openvpn]]
        exe = ^\/usr\/sbin\/openvpn$

extend:
  diamond:
    service:
      - watch:
        - file: openvpn_diamond_collector
