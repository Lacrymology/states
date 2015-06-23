{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - composer

test:
  cmd:
    - run
    - name: composer --version
    - require:
      - sls: composer
