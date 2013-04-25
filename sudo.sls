include:
  - apt

sudo:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
