{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - nrpe
  - backup.client.base.nrpe
  - backup.client.s3
  - bash.nrpe
  - python.dev.nrpe
  - s3cmd.nrpe
  - virtualenv.nrpe

/etc/nagios/backup.yml:
  file:
    - managed
    - template: jinja
    - source: salt://backup/client/s3/nrpe/config.jinja2
    - user: nagios
    - group: nagios
    - mode: 440
    - require:
      - pkg: nagios-nrpe-server

backup_client_nrpe-requirements:
  file:
    - managed
    - name: /usr/local/nagios/backup.client.s3.nrpe-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://backup/client/s3/nrpe/requirements.jinja2
    - require:
      - virtualenv: nrpe-virtualenv
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: /usr/local/nagios/backup.client.s3.nrpe-requirements.txt
    - require:
      - virtualenv: nrpe-virtualenv
    - watch:
      - file: backup_client_nrpe-requirements

check_backup.py:
  file:
    - managed
    - name: /usr/lib/nagios/plugins/check_backup.py
    - source: salt://backup/client/s3/nrpe/check.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - file: /etc/nagios/backup.yml
      - file: /usr/local/nagios/lib/python2.7/check_backup_base.py
      - pkg: nagios-nrpe-server
      - module: backup_client_nrpe-requirements

/etc/nagios/s3lite.yml:
  file:
    - absent

/usr/lib/nagios/plugins/check_backup_s3lite.py:
  file:
    - managed
    - source: salt://backup/client/s3/s3lite/nrpe/check.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - file: /etc/s3lite.yml
      - pkg: nagios-nrpe-server
      - module: nrpe-virtualenv
