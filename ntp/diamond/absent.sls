{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
diamond_ntp:
  file:
    - absent
    - name: /etc/diamond/collectors/NtpdCollector.conf
