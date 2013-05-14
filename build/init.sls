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
