{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - bash.nrpe
  - nrpe

/usr/local/nagios/lib/python2.7/check_backup_base.py:
  file:
    - managed
    - source: salt://backup/client/base/nrpe/check_backup_base.py
    - user: nagios
    - group: nagios
    - mode: 440
    - require:
      - pkg: nagios-nrpe-server
      - module: nrpe-virtualenv
