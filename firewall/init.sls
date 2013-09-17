{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn

Firewall
========

Set a simple iptables based firewall

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.

Optional Pillar
---------------

ip_addresses:
 - 192.168.1.1
firewall:
  filter:
    tcp:
      - 22
      - 80
      - 443
shinken_pollers:
  - 192.168.1.1

ip_addresses: list of host inside internal network that will get full access
    to this server.
firewall:filter: dict of protocol (tcp/udp) with inside it the list of port
    that are allowed from external networks.
shinken_pollers: IP address of monitoring poller that check this server.
-#}
include:
  - apt

/etc/network/iptables.conf:
  file:
    - absent

iptables:
  file:
    - managed
    - name: /etc/iptables/rules.v4
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://firewall/config.jinja2
    - require:
      - pkg: iptables
  pkg:
    - installed
    - pkgs:
      - iptables
      - iptstate
      - iptables-persistent
    - require:
      - cmd: apt_sources
  cmd:
    - wait
    - name: iptables-restore < /etc/iptables/rules.v4
    - stateful: False
    - watch:
      - file: iptables

{% if salt['pillar.get']('firewall:filter', False) and 21 in salt['pillar.get']('firewall:filter:tcp', []) %}
nf_conntrack_ftp:
   kmod:
     - present
{% endif %}
