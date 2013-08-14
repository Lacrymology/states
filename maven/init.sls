include:
  - apt

maven:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
