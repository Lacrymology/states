{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

mysql:
  file:
    - absent
    - name: /etc/apt/sources.list.d/l-mierzwa-lucid-php5-{{ grains['oscodename'] }}.list

libmysqlclient18:
  pkg:
    - purged

mysql-common:
  pkg:
    - purged
    - require:
      - pkg: libmysqlclient18
