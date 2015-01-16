{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


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
