{#
 Install NTP (Network time protocol) server and/or client.
 #}
include:
  - apt

{% if 'servers' in pillar['ntp'] %}
ntpdate:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/default/ntpdate
    - template: jinja
    - source: salt://ntp/ntpdate.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: ntpdate
{% endif %}

ntp:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/ntp.conf
    - template: jinja
    - source: salt://ntp/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: ntp
  service:
    - running
    - require:
      - pkg: ntp
    - watch:
      - file: ntp
