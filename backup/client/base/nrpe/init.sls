{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - bash.nrpe
  - nrpe

/usr/local/nagios/lib/python2.7/check_backup_base.py:
  file:
    - managed
    - source: salt://backup/client/base/nrpe/check_backup_base.py
    - user: root
    - group: nagios
    - mode: 440
    - require:
      - pkg: nagios-nrpe-server
      - module: nrpe-virtualenv
