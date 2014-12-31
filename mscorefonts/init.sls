{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
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
