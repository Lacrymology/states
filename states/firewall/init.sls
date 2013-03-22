include:
  - nrpe
  - sudo
  - gsyslog
  - apt

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

/etc/network/iptables.conf:
  file.absent

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
  cmd:
    - wait
    - name: iptables-restore < /etc/iptables/rules.v4
    - stateful: False
    - watch:
      - file: iptables

{% if 'filter' in pillar['firewall'] %}
{% if 21 in pillar['firewall']['filter']['tcp']|default([]) %}
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

/etc/nagios/nrpe.d/firewall.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://firewall/nrpe.jinja2
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
