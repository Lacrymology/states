include:
  - diamond
  - nginx.diamond


apt_cache_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[apt_cache]]
        exe = /usr/sbin/apt-cacher-ng
