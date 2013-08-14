/etc/mysql:
  file:
    - absent

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
