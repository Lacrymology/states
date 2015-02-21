{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

libjs-underscore:
  pkgrepo:
    - absent
    - ppa: chris-lea/libjs-underscore
  pkg:
    - purged
  file:
    - absent
    - name: /etc/apt/sources.list.d/chris-lea-libjs-underscore-{{ grains['oscodename'] }}.list
    - require:
      - pkgrepo: libjs-underscore
