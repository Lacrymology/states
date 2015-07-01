{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - kernel.image

kernel-headers:
  pkg:
    - latest
    - name: linux-headers-{{ grains['kernelrelease'] }}
    - required:
      - pkg: kernel
