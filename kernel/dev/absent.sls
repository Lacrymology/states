{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

kernel-headers:
  pkg:
    - purged
    - name: linux-headers-{{ grains['kernelrelease'] }}
