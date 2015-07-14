{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

iojs:
  pkg:
    - purged

/usr/lib/node_modules:
  file:
    - absent
    - require:
      - pkg: iojs
