{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
/usr/bin/mail:
  file:
    - symlink
    - target: /etc/alternatives/mail
    - force: True
    - user: root
    - group: root
    - mode: 775
