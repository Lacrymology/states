include:
  - apt

xml-dev:
  pkg:
    - installed
    - names:
      - libxslt1-dev
      - libxml2-dev
    - require:
      - cmd: apt_sources
