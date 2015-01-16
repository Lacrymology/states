{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt
  - rsyslog

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

{% if grains['virtual'] != 'openvzve' %}
firewall_nf_conntrack:
  kmod:
    - present
    - name: nf_conntrack

  {% if salt['pillar.get']('firewall:filter', {})|length > 0 and 21 in salt['pillar.get']('firewall:filter:tcp', []) %}
nf_conntrack_ftp:
   kmod:
     - present
     - require:
       - kmod: firewall_nf_conntrack
  {% endif %}
{% endif %}

/etc/rsyslog.d/firewall.conf:
  file:
    - managed
    - source: salt://firewall/rsyslog.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog
