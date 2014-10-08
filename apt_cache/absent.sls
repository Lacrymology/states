apt_cache:
  pkg:
    - purged
    - name: apt-cacher-ng
    - require:
      - service: apt_cache
  service:
    - dead
    - name: apt-cacher-ng

/etc/nginx/conf.d/apt_cache.conf:
  file:
    - absent
