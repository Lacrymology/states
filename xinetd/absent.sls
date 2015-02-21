{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

xinetd:
  service:
    - dead
  pkg:
    - purged
    - require:
      - service: xinetd
  file:
    - absent
    - name: /etc/xinetd.conf
    - require:
      - pkg: xinetd

/etc/xinetd.d:
  file:
    - absent
    - require:
      - pkg: xinetd
