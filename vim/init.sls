{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Install VIM a vi compatible editor.
-#}
include:
  - apt

vim:
  pkg:
    - latest
    - require:
      - cmd: apt_sources

vim-tiny:
  pkg:
    - purged
