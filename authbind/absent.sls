{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

authbind:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/authbind
    - require:
      - pkg: authbind
