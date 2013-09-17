{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn

Build Dependencies
==================

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
    - require:
      - cmd: apt_sources
