include:
  - python
  - apt
  - build

python-dev:
  pkg:
    - latest
    - name:
      - python2.7-dev
    - require:
      - pkg: build
      - cmd: apt_sources
      - pkg: python
