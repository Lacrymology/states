{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

apt_cache:
  pkg:
    - purged
    - name: apt-cacher-ng
    - require:
      - service: apt_cache
  service:
    - dead
    - name: apt-cacher-ng

apt_cache_absent_log:
  file:
    - absent
    - name: /var/log/apt-cacher-ng
    - require:
      - pkg: apt_cache

/etc/nginx/conf.d/apt_cache.conf:
  file:
    - absent

/etc/apt-cacher-ng:
  file:
    - absent
    - require:
      - pkg: apt_cache
