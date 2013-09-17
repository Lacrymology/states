{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Turn off Diamond statistics for Memcache
-#}
memcached_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/MemcachedCollector.conf
