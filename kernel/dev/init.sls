{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - kernel

kernel-headers:
  pkg:
    - latest
    - name: linux-headers-{{ grains['kernelrelease'] }}
    - required:
      - pkg: kernel
