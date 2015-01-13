{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
tmpreaper:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/tmpreaper.conf
    - require:
      - pkg: tmpreaper
