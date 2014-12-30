{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - cron.nrpe
  - nrpe
  - pip.nrpe
  - pysc.nrpe
  - rsyslog.nrpe
  - sudo
  - sudo.nrpe
  - ssh.server.nrpe

/usr/local/bin/check_backups.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_backups.py:
  file:
    - managed
    - user: root
    - group: root
    - mode: 550
    - source: salt://backup/server/nrpe/check.py
    - require:
      - virtualenv: nrpe-virtualenv
      - pkg: nagios-nrpe-server
      - file: nsca-backup.server
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

/etc/sudoers.d/nrpe_backups:
  file:
    - managed
    - source: salt://backup/server/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - template: jinja
    - require:
      - pkg: sudo
    - require_in:
      - file: nsca-backup.server

/etc/nagios/nrpe.d/backups.cfg:
  file:
    - absent
    - watch_in:
      - service: nagios-nrpe-server

{{ passive_check('backup.server') }}
