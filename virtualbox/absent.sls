{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

virtualbox:
  pkg:
    - removed

/usr/lib/virtualbox:
  file:
    - absent
    - require:
      - pkg: virtualbox
