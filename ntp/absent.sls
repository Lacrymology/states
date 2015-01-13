{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
ntpdate:
  pkg:
    - purged
    - require:
      - pkg: ntp
  file:
    - absent
    - name: /etc/default/ntpdate
    - require:
      - pkg: ntpdate

ntp:
  pkg:
    - purged
    - require:
      - service: ntp
  file:
    - absent
    - name: /etc/ntp.conf
    - require:
      - pkg: ntp
  service:
    - dead
    - enable: False
