{#
 Install Nagios NRPE Agent
#}
#TODO: set nagios user shell to /bin/false

include:
  - pip
  - pip.nrpe
  - virtualenv
  - virtualenv.nrpe
  - apt
  - apt.nrpe
{% if 'graphite_address' in pillar %}
  - nrpe.diamond
{% endif %}
  - nrpe.gsyslog
  - gsyslog
  - gsyslog.nrpe

/usr/local/nagiosplugin:
  file:
    - absent

{{ opts['cachedir'] }}/nagiosplugin-requirements.txt:
  file:
    - absent

nrpe-virtualenv:
  virtualenv:
    - manage
    - upgrade: True
    - name: /usr/local/nagios
    - require:
      - module: virtualenv
  file:
    - managed
    - name: /usr/local/nagios/nagiosplugin-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nrpe/requirements.jinja2
    - require:
      - virtualenv: nrpe-virtualenv
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: /usr/local/nagios/nagiosplugin-requirements.txt
    - require:
      - virtualenv: nrpe-virtualenv
    - watch:
      - file: nrpe-virtualenv
  pip:
    - removed
    - name: nagiosplugin
    - require:
      - module: pip

nagios-nrpe-server:
  pkg:
    - latest
    - names:
      - nagios-nrpe-server
      - nagios-plugins-standard
      - nagios-plugins-basic
    - require:
      - cmd: apt_sources
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
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - pkg: nagios-nrpe-server
