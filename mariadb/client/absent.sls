mariadb-client-5.5:
  pkg:
    - purged

mysql-client:
  pkg:
    - purged
    - name: mariadb-client
    - require:
      - pkg: mariadb-client-5.5
