{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

vim:
  pkg:
    - latest
    - require:
      - cmd: apt_sources

vim-tiny:
  pkg:
    - purged
