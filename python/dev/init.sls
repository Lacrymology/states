include:
  - python
  - apt
  - build

python-dev:
  pkg:
    - latest
    - name:
      - python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}-dev
    - require:
      - pkg: build
      - cmd: apt_sources
      - pkg: python
