kernel-headers:
  pkg:
    - purged
    - name: linux-headers-{{ grains['kernelrelease'] }}
