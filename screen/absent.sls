{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Undo screen state
 -#}
/etc/screenrc:
  file:
    - absent

screen:
  pkg:
    - purged
