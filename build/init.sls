include:
  - apt

build:
  pkg:
    - installed
    - name: build-essential
    - require:
      - cmd: apt_sources
