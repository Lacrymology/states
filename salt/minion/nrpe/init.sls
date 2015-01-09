{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Nagios NRPE check for Salt Minion.
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - nrpe
  - pysc.nrpe
  - raven.nrpe
  - requests.nrpe
  - rsyslog.nrpe
  - sudo
  - sudo.nrpe

sudo_salt_minion_nrpe:
  file:
    - managed
    - name: /etc/sudoers.d/salt_minion_nrpe
    - template: jinja
    - source: salt://salt/minion/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

/usr/lib/nagios/plugins/check_minion_last_success.py:
  file:
    - managed
    - source: salt://salt/minion/nrpe/check_last_success.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server
      - file: nsca-salt.minion
      - file: sudo_salt_minion_nrpe
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

/usr/lib/nagios/plugins/check_minion_pillar_render.py:
  file:
    - managed
    - source: salt://salt/minion/nrpe/check_pillar.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server
      - file: nsca-salt.minion
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

{{ passive_check('salt.minion') }}
