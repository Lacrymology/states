/etc/exports:
  file:
    - absent
    - require:
      - pkg: nfs-kernel-server

/etc/default/nfs-kernel-server:
  file:
    - absent
    - require:
      - pkg: nfs-kernel-server

nfs-kernel-server:
  pkg:
    - purged
    - require:
      - service: nfs-kernel-server
  service:
    - dead
    - enable: False
