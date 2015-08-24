{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
{%- from "os.jinja2" import os with context %}
include:
  - apt

dhcp-server:
  pkg:
    - latest
    - name: isc-dhcp-server
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/dhcp/dhcpd.conf
    - template: jinja
    - source: salt://dhcp/server/config.jinja2
    - user: root
    - group: dhcpd
    - mode: 440
    - context:
        subnet: {{ salt["pillar.get"]("dhcp_server:subnet") }}
        netmask: {{ salt["pillar.get"]("dhcp_server:netmask") }}
        range: {{ salt["pillar.get"]("dhcp_server:range") }}
        options: {{ salt["pillar.get"]("dhcp_server:options", {}) }}
        reservations: {{ salt["pillar.get"]("dhcp_server:reservations", {}) }}
    - require:
      - pkg: dhcp-server
  service:
    - running
    - name: isc-dhcp-server
    - watch:
      - file: /etc/default/isc-dhcp-server
      - file: dhcp-server
      - pkg: dhcp-server

{%- set subnet6 = salt["pillar.get"]("dhcp_server:subnet6", None) %}
{%- set range6 = salt["pillar.get"]("dhcp_server:range6", None) %}
{%- set enabled_ipv6 = subnet6 and range6 %}

dhcp-server6:
{%- if enabled_ipv6 %}
  file:
    - managed
    - name: /etc/dhcp/dhcpd6.conf
    - template: jinja
    - source: salt://dhcp/server/config6.jinja2
    - user: root
    - group: dhcpd
    - mode: 440
    - context:
        subnet6: {{ subnet6 }}
        range6: {{ range6 }}
        options6: {{ salt["pillar.get"]("dhcp_server:options6", {}) }}
        reservations6: {{ salt["pillar.get"]("dhcp_server:reservations6", {}) }}
    - require:
      - pkg: dhcp-server
  service:
    - running
    - name: isc-dhcp-server6
    - enable: True
    - watch:
      - file: /etc/default/isc-dhcp-server
      - file: dhcp-server6
      - pkg: dhcp-server
{%- else %}
  file:
    - absent
    - name: /etc/dhcp/dhcpd6.conf
    - require:
      - service: dhcp-server6
  service:
    - dead
    - name: isc-dhcp-server6
    - enable: False
{%- endif %}

/etc/default/isc-dhcp-server:
  file:
    - managed
    - template: jinja
    - source: salt://dhcp/server/default.jinja2
    - user: root
    - group: root
    - mode: 440
    - context:
        interface: {{ salt["pillar.get"]("dhcp_server:interface") }}
    - require:
      - pkg: dhcp-server

{%- if os.is_trusty %}
{#-
workaround for: isc-dhcp-server fails to renew lease file
https://bugs.launchpad.net/ubuntu/+source/isc-dhcp/+bug/1186662
#}
dhcp-server_acl:
  pkg:
    - latest
    - name: acl
    - require:
      - cmd: apt_sources
  cmd:
    - run
    - name: setfacl -m u:dhcpd:rwx /var/lib/dhcp
    - unless: getfacl /var/lib/dhcp | grep user:dhcpd:rwx
    - require:
      - pkg: dhcp-server
      - pkg: dhcp-server_acl
    - watch_in:
      - service: dhcp-server

dhcp-server_acl_default:
  cmd:
    - run
    - name: setfacl -dm u:dhcpd:rwx /var/lib/dhcp
    - unless: getfacl /var/lib/dhcp | grep default:user:dhcpd:rwx
    - require:
      - pkg: dhcp-server
      - pkg: dhcp-server_acl
    - watch_in:
      - service: dhcp-server
{%- endif %}
