{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt
  - build
  - python.dev

pillow-dependencies:
  pkg:
    - installed
    - pkgs:
      - libfreetype6-dev
      - libjpeg-dev
    - require:
      - cmd: apt_sources
      - pkg: python-dev
      - pkg: build
