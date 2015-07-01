{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

kernel:
  pkg:
    - installed
    - name: linux-image-{{ grains['kernelrelease'] }}
    - required:
      - cmd: apt_sources
