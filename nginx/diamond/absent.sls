{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Diamond statistics for Nginx
-#}
nginx_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/NginxCollector.conf
