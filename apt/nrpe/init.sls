{#
 Nagios NRPE check for APT
#}
include:
  - nrpe

/usr/local/bin/check_apt-rc.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_apt-rc.py:
  file:
    - managed
    - source: salt://apt/nrpe/check.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server

/etc/nagios/nrpe.d/apt.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://apt/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
      - file: /usr/lib/nagios/plugins/check_apt-rc.py

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/apt.cfg
