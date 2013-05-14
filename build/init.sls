include:
  - apt

build:
  pkg:
    - installed
    - names:
      - g++
      - gcc
      - libc-dev
      - make
    - require:
      - cmd: apt_sources
