{#
 Remove Diamond statistics for Nginx
#}
nginx_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/NginxCollector.conf
