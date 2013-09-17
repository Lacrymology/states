{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
/usr/local:
  file:
    - directory
    - name: /usr/local/bin
    - makedirs: True
    - user: root
    - group: root
    - mode: 755
