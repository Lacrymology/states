{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
rssh:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/rssh.conf
    - require:
      - pkg: rssh
