{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - backup.client.noop
  - backup.client.noop.nrpe
  - doc

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 30
