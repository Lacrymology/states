{#
 Install Denyhosts used to block SSH brute-force attack
 #}
include:
  - apt
  - gsyslog

/var/lib/denyhosts/allowed-hosts:
  file:
    - managed
    - source: salt://denyhosts/allowed.jinja2
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - require:
      - pkg: denyhosts

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
  service:
    - running
    - watch:
      - file: denyhosts
      - pkg: denyhosts
      - file: /var/lib/denyhosts/allowed-hosts
    - require:
      - service: gsyslog

{% for file in ('/etc/logrotate.d/denyhosts', '/var/log/denyhosts') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: denyhosts
{% endfor %}
