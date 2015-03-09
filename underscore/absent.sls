{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

libjs-underscore:
{# only for ubuntu precise #}
  pkgrepo:
    - absent
    - ppa: chris-lea/libjs-underscore
  file:
    - absent
    - name: /etc/apt/sources.list.d/chris-lea-libjs-underscore-{{ grains['oscodename'] }}.list
    - require:
      - pkgrepo: libjs-underscore
{# end for ubuntu precise #}
  pkg:
    - purged
