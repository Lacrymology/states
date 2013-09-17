{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Uninstall TMPReaper that cleanup /tmp for left over files.
 -#}
tmpreaper:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/tmpreaper.conf
    - require:
      - pkg: tmpreaper
