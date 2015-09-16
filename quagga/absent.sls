{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

quagga:
  service:
    - dead
  pkg:
    - purged
    - require:
      - service: quagga
  group:
    - absent
    - name: quaggavty
    - require:
      - pkg: quagga
  user:
    - absent
    - name: quaggavty
    - require:
      - group: quagga
