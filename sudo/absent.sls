{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
sudo:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/sudoers.d
    - require:
      - pkg: sudo
