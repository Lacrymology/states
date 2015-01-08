{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Lam Dang Tung <lam@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
include:
  - apt

erlang:
  pkg:
    - latest
    - name: erlang-nox
    - require:
      - cmd: apt_sources
