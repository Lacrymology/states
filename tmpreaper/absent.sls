{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

tmpreaper:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/tmpreaper.conf
    - require:
      - pkg: tmpreaper
