{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - nrpe
  - rsyslog.nrpe
  - sudo
  - sudo.nrpe

/etc/sudoers.d/nrpe_firewall:
  file:
    - managed
    - template: jinja
    - source: salt://firewall/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

/usr/lib/nagios/plugins/check_firewall.py:
  file:
    - managed
    - source: salt://firewall/nrpe/check.py
    - mode: 550
    - user: root
    - group: root
    - require:
      - module: nrpe-virtualenv
      - file: /etc/sudoers.d/nrpe_firewall
      - pkg: nagios-nrpe-server
      - file: nsca-firewall
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

{{ passive_check('firewall') }}
