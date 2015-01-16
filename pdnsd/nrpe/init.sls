{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - nrpe
  - pip
  - sudo
  - sudo.nrpe

sudo_pdnsd_nrpe:
  file:
    - managed
    - name: /etc/sudoers.d/pdnsd_nrpe
    - template: jinja
    - source: salt://pdnsd/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

pydns:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/pydns
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://pdnsd/nrpe/requirements.jinja2
    - require:
      - file: {{ opts['cachedir'] }}/pip
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pip/pydns
    - require:
      - module: pip
    - watch:
      - file: pydns

/usr/lib/nagios/plugins/check_dns_caching.py:
  file:
    - managed
    - source: salt://pdnsd/nrpe/check.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server
      - file: nsca-pdnsd
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

{{ passive_check('pdnsd') }}
