{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
include:
  - ruby
  - ruby.nrpe

test_ruby:
  cmd:
    - run
    - name: ruby -v
    - require:
      - pkg: ruby
  monitoring:
    - run_all_checks
    - order: last
