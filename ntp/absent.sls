{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

ntpdate:
  pkg:
    - purged
    - require:
      - pkg: ntp
  file:
    - absent
    - name: /etc/default/ntpdate
    - require:
      - pkg: ntpdate

ntp:
  pkg:
    - purged
    - require:
      - service: ntp
  file:
    - absent
    - name: /etc/ntp.conf
    - require:
      - pkg: ntp
  service:
    - dead
    - enable: False
