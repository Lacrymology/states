{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt
  - python.dev

pillow-dependencies:
  pkg:
    - installed
    - names:
      - libfreetype6-dev
      - libjpeg-dev
      - zlib1g-dev
    - require:
      - cmd: apt_sources
      - pkg: python-dev
