{#
 Install Nagios NRPE Agent
#}
include:
  - pip
  - gsyslog
  - diamond

/usr/local/nagiosplugin:
  file:
    - absent

nagiosplugin:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/nagiosplugin-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nrpe/requirements.jinja2
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/nagiosplugin-requirements.txt
    - require:
      - pkg: python-pip
    - watch:
      - file: nagiosplugin

nagios-nrpe-server:
  pkg:
    - latest
    - names:
      - nagios-nrpe-server
      - nagios-plugins-standard
      - nagios-plugins-basic
  file:
    - managed
    - name: /etc/nagios/nrpe.d/000-nagios-servers.cfg
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
  service:
    - running
    - enable: True
    - watch:
      - pkg: nagios-nrpe-server
      - file: nagios-nrpe-server

/usr/local/bin/check_memory.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_memory.py:
  file:
    - managed
    - source: salt://nrpe/check.py
    - user: root
    - group: root
    - mode: 555

nrpe_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[nrpe]]
        exe = ^\/usr\/sbin\/nrpe$
        cmdline = ^\/usr\/lib\/nagios\/plugins\/check_

{% if not pillar['debug'] %}
/etc/gsyslog.d/nrpe.conf:
  file:
    - managed
    - template: jinja
    - source: salt://nrpe/gsyslog.jinja2
    - user: root
    - group: root
    - mode: 440

extend:
  gsyslog:
    service:
      - watch:
        - file: /etc/gsyslog.d/nrpe.conf
{% endif %}
