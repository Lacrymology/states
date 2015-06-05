{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
ppp:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/ppp
    - require:
      - pkg: ppp
