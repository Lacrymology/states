{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

pam:
  pkg:
    - installed
    - name: libpam-modules
    - require:
      - cmd: apt_sources
