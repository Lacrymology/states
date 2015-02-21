{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

ssl-cert:
  pkg:
    - purged
  group:
    - absent
    - require:
      - pkg: ssl-cert
  file:
    - absent
    - name: /etc/ssl
    - require:
      - pkg: ssl-cert
