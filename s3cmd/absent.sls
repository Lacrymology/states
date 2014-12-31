{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Nicolas Plessis <niplessis@gmail.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
s3cmd:
  pkg:
    - purged

/root/.s3cfg:
  file:
    - absent
    - require:
      - pkg: s3cmd
