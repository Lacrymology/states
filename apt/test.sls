{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
include:
  - apt
  - apt.nrpe
  - doc

{#-
 Install a dummy package, then remove it and expect a HALF INSTALLED after
 checking.
#}
install_screen:
  pkg:
    - installed
    - name: screen
    - require:
      - cmd: apt_sources

remove_screen:
  pkg:
    - removed
    - name: screen
    - require:
      - pkg: install_screen

apt_rc:
  monitoring:
    - run_check
    - accepted_failure: 'HALFREMOVED CRITICAL'
    - require:
      - file: /usr/lib/nagios/plugins/check_apt-rc.py
      - pkg: remove_screen
  pkg:
    - purged
    - name: screen
    - require:
      - monitoring: apt_rc
    - require_in:
      - monitoring: test

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: apt
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
