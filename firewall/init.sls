{#
 Set a simple iptables based firewall
 #}
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
    - names:
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
