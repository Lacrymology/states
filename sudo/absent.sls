{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
sudo:
  pkg:
    - purged
    - env:
        'SUDO_FORCE_REMOVE': 'yes'
  file:
    - absent
    - name: /etc/sudoers.d
    - require:
      - pkg: sudo
