include:
  - kernel

kernel-headers:
  pkg:
    - latest
    - name: linux-headers-{{ grains['kernelrelease'] }}
    - required:
      - pkg: kernel
