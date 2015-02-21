{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
