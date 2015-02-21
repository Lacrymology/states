{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
