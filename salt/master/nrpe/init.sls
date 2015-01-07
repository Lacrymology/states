{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Nagios NRPE check for Salt Master.
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - git.nrpe
  - pip.nrpe
  - nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
  - ssh.client.nrpe
  - sudo
  - sudo.nrpe

/etc/sudoers.d/nrpe_salt_master:
  file:
    - managed
    - template: jinja
    - source: salt://salt/master/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

/usr/lib/nagios/plugins/check_mine_minions.py:
  file:
    - managed
    - source: salt://salt/master/nrpe/check_mine.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - pkg: nagios-nrpe-server
      - module: nrpe-virtualenv
      - file: /etc/sudoers.d/nrpe_salt_master
      - file: nsca-salt.master
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

{{ passive_check('salt.master') }}
