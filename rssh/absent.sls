{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
rssh:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/rssh.conf
    - require:
      - pkg: rssh
