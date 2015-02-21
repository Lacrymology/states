{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
