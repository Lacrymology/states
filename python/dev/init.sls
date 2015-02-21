{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - build
  - python

python-dev:
  pkg:
    - latest
    - name:
      - python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}-dev
    - require:
      - pkg: build
      - cmd: apt_sources
      - pkg: python
