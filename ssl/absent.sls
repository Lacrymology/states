{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
ssl-cert:
  pkg:
    - purged
  group:
    - absent
    - require:
      - pkg: ssl-cert
  file:
    - absent
    - name: /etc/ssl
    - require:
      - pkg: ssl-cert
