{#
 Set a simple iptables based firewall
 #}
include:
  - nrpe
  - sudo
  - gsyslog
  - apt

{#
 this is a constant used to define the -c flag of nagios check that set the
 maximal number of iptables rules before it's considered critical.
 the number is high because we only care about 0 iptables, where there is just
 no rules applied.
 #}
{% set critical=300 %}

{% if 'firewall' in pillar %}
iptables-persistent:
  debconf:
    - set
    - data:
{% for version in (4, 6) %}
        'iptables-persistent/autosave_v{{ version }}': {'type': 'boolean', 'value': 'false'}
{% endfor %}
    - require:
      - pkg: debconf-utils
  pkg:
    - installed
    - require:
      - debconf: iptables-persistent
      - cmd: apt_sources

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
      - pkg: iptables-persistent
  pkg:
    - installed
    - names:
      - iptables
      - iptstate
    - require:
      - cmd: apt_sources
  cmd:
    - wait
    - name: iptables-restore < /etc/iptables/rules.v4
    - stateful: False
    - watch:
      - file: iptables

{% if salt['pillar.get']('firewall:filter', False) %}
{% if 21 in salt['pillar.get']('firewall:filter:tcp', []) %}
nf_conntrack_ftp:
   kmod:
     - present
{% endif %}
{% endif %}
{% endif %}

/etc/sudoers.d/nrpe_firewall:
  file:
    - managed
    - template: jinja
    - source: salt://firewall/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - module: nagiosplugin
      - pkg: sudo

/usr/local/bin/check_firewall.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_firewall.py:
  file:
    - managed
    - source: salt://firewall/check.py
    - mode: 550
    - user: root
    - group: root
    - require:
      - module: nagiosplugin
      - file: /etc/sudoers.d/nrpe_firewall

/etc/gsyslog.d/firewall.conf:
  file:
    - managed
    - source: salt://firewall/gsyslog.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: root
    - context:
      critical: {{ critical }}
    - require:
      - file: /etc/gsyslog.d

/etc/nagios/nrpe.d/firewall.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://firewall/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      critical: {{ critical }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/firewall.cfg
  gsyslog:
    service:
      - watch:
        - file: /etc/gsyslog.d/firewall.conf
