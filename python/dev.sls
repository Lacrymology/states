include:
  - python
  - apt

build-essential:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

python-dev:
  pkg:
    - latest
    - name:
      - python2.7-dev
    - require:
      - pkg: build-essential
      - cmd: apt_sources
      - pkg: python
