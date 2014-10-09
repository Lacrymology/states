kernel-headers:
  pkg:
    - absent
    - name: linux-headers-{{ grains['kernelrelease'] }}
