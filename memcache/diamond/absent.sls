{#
 Turn off Diamond statistics for Memcache
#}
/etc/diamond/collectors/MemcachedCollector.conf:
  file:
    - absent
