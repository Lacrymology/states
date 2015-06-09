{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

virtualbox:
  pkg:
    - purged
  group:
    - absent
    - name: vboxusers
    - require:
      - pkg: virtualbox

/usr/lib/virtualbox:
  file:
    - absent
    - require:
      - pkg: virtualbox
