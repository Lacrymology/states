{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - nrpe
  - sudo
  - sudo.nrpe

/etc/sudoers.d/check_apt:
  file:
    - managed
    - source: salt://apt/nrpe/sudo.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

/usr/lib/nagios/plugins/check_apt-rc.py:
  file:
    - managed
    - source: salt://apt/nrpe/check.py
    - user: root
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server
      - file: nsca-apt
      - file: /etc/sudoers.d/check_apt
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

{{ passive_check('apt') }}
