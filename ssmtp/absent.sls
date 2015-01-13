{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
ssmtp:
  pkg:
    - purged
    - pkgs:
      - bsd-mailx
      - ssmtp
  file:
    - absent
    - name: /etc/ssmtp
    - require:
      - pkg: ssmtp
