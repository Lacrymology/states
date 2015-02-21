{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

ssl-dev:
  pkg:
    - installed
    - name: libssl-dev
    - require:
      - cmd: apt_sources
