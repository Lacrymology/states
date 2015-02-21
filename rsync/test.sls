{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - rsync
  - rsync.diamond
  - rsync.nrpe
  - xinetd

rsync_test_file:
  file:
    - managed
    - name: /tmp/ci_test_rsync
    - user: root
    - group: root
    - mode: 444
    - contents: "For rsync testing purpose"

test:
  cmd:
    - run
    - name: rsync -av rsync://127.0.0.1/test/ci_test_rsync /tmp/ci_test_rsync_received
    - require:
      - pkg: rsync
      - file: rsync_test_file
      - service: xinetd
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: rsync
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

clean_rsync_test_file:
  file:
    - absent
    - name: /tmp/ci_test_rsync
    - require:
      - cmd: test

clean_rsync_test_file_received:
  file:
    - absent
    - name: /tmp/ci_test_rsync_received
    - require:
      - cmd: test
