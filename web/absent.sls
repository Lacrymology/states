{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
web:
  user:
    - absent
    - name: www-data
  file:
    - absent
    - name: /var/www
    - require:
      - user: web
