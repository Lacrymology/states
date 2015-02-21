{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

mscorefonts:
  pkg:
    - installed
    - name: ttf-mscorefonts-installer
    - require:
      - debconf: set_mscorefonts
      - cmd: apt_sources

set_mscorefonts:
  debconf:
    - set
    - name: ttf-mscorefonts-installer
    - data:
        msttcorefonts/accepted-mscorefonts-eula: {'type': 'boolean', 'value': True}
    - require:
      - pkg: apt_sources
