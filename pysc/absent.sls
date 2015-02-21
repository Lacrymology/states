{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
