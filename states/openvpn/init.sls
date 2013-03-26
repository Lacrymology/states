include:
  - apt
  - diamond
  - nrpe

openvpn:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

/etc/nagios/nrpe.d/openvpn.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://openvpn/nrpe.jinja2
    - context:
      instances: {{ pillar['openvpn']|default({}) }}

/etc/default/openvpn:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://openvpn/default.jinja2
    - require:
      - pkg: openvpn

openvpn_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/OpenVPNCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://openvpn/diamond.jinja2
    - context:
      instances: {{ pillar['openvpn']|default({}) }}

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

{% for type in ('lib', 'log') %}
/var/{{ type }}/openvpn:
  file:
    - directory
    - user: root
    - group: root
    - mode: 770
{% endfor %}

extend:
  diamond:
    service:
      - watch:
        - file: openvpn_diamond_collector
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/openvpn.cfg
