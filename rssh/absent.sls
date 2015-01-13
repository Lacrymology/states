{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
rssh:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/rssh.conf
    - require:
      - pkg: rssh
