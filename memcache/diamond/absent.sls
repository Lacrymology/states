{#
 Turn off Diamond statistics for Memcache
#}
memcached_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/MemcachedCollector.conf
