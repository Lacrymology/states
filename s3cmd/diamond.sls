{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Nicolas Plessis <niplessis@gmail.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}

include:
  - diamond

s3cmd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[s3cmd]]
        cmdline = ^\/usr\/bin\/python \/usr\/local\/local\/bin\/s3cmd
