{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt

xml-dev:
  pkg:
    - installed
    - pkgs:
      - libxslt1-dev
      - libxml2-dev
    - require:
      - cmd: apt_sources
