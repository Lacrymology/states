{#
 Install Nagios NRPE Agent
#}
#TODO: set nagios user shell to /bin/false

include:
  - local
  - pip
  - pip.nrpe
  - virtualenv
  - virtualenv.nrpe
  - apt
  - apt.nrpe
{% if 'graphite_address' in pillar %}
  - nrpe.diamond
{% endif %}
  - nrpe.rsyslog
  - rsyslog
  - rsyslog.nrpe
  - sudo

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
      - file: /usr/local
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

nagios-plugins:
  pkg:
    - installed
    - names:
      - nagios-plugins-standard
      - nagios-plugins-basic

nagios-nrpe-server:
  pkg:
    - latest
    - require:
      - pkg: nagios-plugins
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
    - order: 50
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

/usr/lib/nagios/plugins/check_oom.py:
  file:
    - managed
    - source: salt://nrpe/check_oom.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - pkg: nagios-nrpe-server

/etc/sudoers.d/nrpe_oom:
  file:
    - managed
    - template: jinja
    - source: salt://nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo
