{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

rssh:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/rssh.conf
    - require:
      - pkg: rssh
