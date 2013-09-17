{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Undo motd state
-#}
/etc/motd.tail:
  file:
    - absent
