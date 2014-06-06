include:
  - apt

unzip:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
