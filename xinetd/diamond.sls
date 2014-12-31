{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Van Diep Pham <favadi@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
include:
  - diamond

xinetd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[xinetd]]
        exe = ^\/usr\/sbin\/xinetd$
