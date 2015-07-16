{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

openssl:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
