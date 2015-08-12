{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - local

/usr/local/bin/find_writable.py:
  file:
    - managed
    - source: salt://tools/find_writable.py
    - user: root
    - group: root
    - mode: 550
    - require:
      - file: /usr/local
