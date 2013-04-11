{#
 Install Denyhosts used to block SSH brute-force attack
 #}
include:
  - apt
  - gsyslog
  - diamond
  - nrpe

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

denyhosts_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[denyhosts]]
        cmdline = ^python \/usr\/sbin\/denyhosts

/etc/nagios/nrpe.d/denyhosts.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://denyhosts/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/denyhosts.cfg

{% for file in ('/etc/logrotate.d/denyhosts', '/var/log/denyhosts') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: denyhosts
{% endfor %}
