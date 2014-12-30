{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

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
    - require:
      - cmd: apt_sources
