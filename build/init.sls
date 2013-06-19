{#-
Build Dependencies
==================

Install Packages required to build C/C++ code.
-#}
include:
  - apt

build:
  pkg:
    - installed
    - names:
      - g++
      - gcc
      - make
    - require:
      - cmd: apt_sources
