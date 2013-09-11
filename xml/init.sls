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
