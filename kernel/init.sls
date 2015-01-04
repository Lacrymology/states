{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
include:
  - apt

kernel:
  pkg:
    - installed
    - name: linux-image-{{ grains['kernelrelease'] }}
    - required:
      - cmd: apt_sources
