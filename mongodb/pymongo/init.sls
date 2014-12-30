{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Diep Pham <favadi@robotinfra.com>
Maintainer: Diep Pham <favadi@robotinfra.com>
-#}

include:
  - apt

python-pymongo:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
