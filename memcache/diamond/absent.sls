{#
 Turn off Diamond statistics for Memcache
#}
{% if 'graphite_address' in pillar %}
include:
  - diamond

extend:
  diamond:
    service:
      - watch:
        - file: /etc/diamond/collectors/MemcachedCollector.conf
{% endif %}

/etc/diamond/collectors/MemcachedCollector.conf:
  file:
    - absent
