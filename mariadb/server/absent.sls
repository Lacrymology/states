absent_/etc/mysql:
  file:
    - absent
    - name: /etc/mysql

absent_mariadb-server:
  service:
    - name: mysql
    - dead

{%- for pkg in 'mysql-common', 'mariadb-common', 'mariadb-server-5.5', 'mariadb-client-5.5' %}
absent_{{ pkg }}:
  pkg:
    - purged
    - name: {{ pkg }}
    - require_in:
      - file: absent_/etc/mysql
    - require:
      - service: absent_mariadb-server
{%- endfor %}
