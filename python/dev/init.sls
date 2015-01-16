{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
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
