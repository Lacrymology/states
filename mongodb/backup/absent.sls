{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
/usr/local/bin/backup-mongodb:
  file:
    - absent

/usr/local/bin/backup-mongodb-all:
  file:
    - absent
