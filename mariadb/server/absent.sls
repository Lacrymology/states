{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
/etc/mysql:
  file:
    - absent
    - require:
      - pkg: mysql-server

mysql-server:
  service:
    - name: mysql
    - dead
  pkg:
    - purged
    - name: mariadb-server-5.5
    - require_in:
      - file: /etc/mysql
    - require:
      - service: mysql-server
  user:
    - absent
    - name: mysql
    - require:
      - pkg: mysql-server
  group:
    - absent
    - name: mysql
    - require:
      - user: mysql-server
  cmd:
    - run
    - name: update-rc.d -f mysql remove
    - require:
      - pkg: mysql-server
  file:
    - absent
    - name: /var/lib/mysql
    - require:
      - pkg: mysql-server

{%- for extension in ('/', '.log', '.err') %}
/var/log/mysql{{ extension }}:
  file:
    - absent
    - require:
      - pkg: mysql-server
{%- endfor -%}
