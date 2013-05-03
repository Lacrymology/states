{#
 Install Denyhosts used to block SSH brute-force attack
 #}
include:
  - apt
  - gsyslog

denyhosts:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - source: salt://denyhosts/config.jinja2
    - name: /etc/denyhosts.conf
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - require:
      - pkg: denyhosts
  service:
    - running
    - enable: True
    - watch:
      - file: denyhosts
      - pkg: denyhosts
    - require:
      - service: gsyslog

{% for file in ('/etc/logrotate.d/denyhosts', '/var/log/denyhosts') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: denyhosts
{% endfor %}
