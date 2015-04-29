{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
    - name: mysql-server-5.5
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

/var/log/upstart/mysql.log:
  file:
    - absent
    - require:
      - service: mysql-server

{%- for extension in ('/', '.log', '.err') %}
/var/log/mysql{{ extension }}:
  file:
    - absent
    - require:
      - pkg: mysql-server
{%- endfor -%}
