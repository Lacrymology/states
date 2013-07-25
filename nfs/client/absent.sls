/etc/default/nfs-common:
  file:
    - absent

nfs-common:
  pkg:
    - purged
