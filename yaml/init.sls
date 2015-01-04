{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
et ma-#}
include:
  - apt

yaml:
  pkg:
    - installed
    - name: libyaml-dev
    - require:
      - cmd: apt_sources
