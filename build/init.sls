{#- Usage of this is governed by a license that can be found in doc/license.rst

Build Dependencies.
Install Packages required to build C/C++ code.
-#}

include:
  - apt

build:
  pkg:
    - installed
    - pkgs:
      - g++
      - gcc
      - make
      - zlib1g-dev
    - require:
      - cmd: apt_sources
