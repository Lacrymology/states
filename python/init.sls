{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt

/etc/python:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755

python:
  pkg:
    - latest
    - name: python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/python/config.yml
    - source: salt://python/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - require:
      - file: /etc/python
