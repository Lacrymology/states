{#
 Install and run one or multiple OpenVPN servers
 #}
include:
  - apt

openvpn:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

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

{%- for tunnel in pillar['openvpn']|default([]) %}
openvpn-{{ tunnel }}:
  file:
    - managed
    - name: /etc/init/openvpn-{{ tunnel }}.conf
    - user: root
    - group: root
    - mode: 440
    - source: salt://openvpn/upstart.jinja2
    - template: jinja
    - require:
      - file: /etc/openvpn/{{ tunnel }}/config
    - context:
      identifier: {{ tunnel }}
  service:
    - running
    - order: 50
    - watch:
      - file: openvpn-{{ tunnel }}
{%- endfor %}

{% for type in ('lib', 'log') %}
/var/{{ type }}/openvpn:
  file:
    - directory
    - user: root
    - group: root
    - mode: 770
{% endfor %}
