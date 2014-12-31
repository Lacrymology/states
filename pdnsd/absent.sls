{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>

-#}
pdnsd:
  pkg:
    - purged
    - require:
      - service: pdnsd
  service:
    - dead
    - enable: False
  user:
    - absent
    - require:
      - pkg: pdnsd

{% for file in ('default/pdnsd', 'pdnsd.conf') %}
/etc/{{ file }}:
  file:
    - absent
    - require:
      - pkg: pdnsd
{% endfor %}
