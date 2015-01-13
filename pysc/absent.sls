{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
#}
pysc:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/pysc
  module:
    - wait
    - name: pip.uninstall
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pip/pysc
    - require_in:
      - file: pysc

pysc_log_test:
  file:
    - absent
    - name: /usr/local/bin/log_test.py
