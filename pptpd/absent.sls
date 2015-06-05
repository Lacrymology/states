{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

pptpd:
  pkg:
    - purged
    - require:
      - service: pptpd
  file:
    - absent
    - name: /etc/pptpd.conf
    - require:
      - pkg: pptpd
  service:
    - dead
    - enable: False

ppp_mppe:
  kmod:
    - absent
    - persist: True
    - require:
      - file: pptpd
  file:
    - absent
    - name: /etc/modules.bak
    - require:
      - kmod: ppp_mppe
