/etc/mysql:
  file:
    - absent

mysql-server:
  service:
    - name: mysql
    - dead

{%- for pkg in 'mysql-common', 'mariadb-common', 'mariadb-server-5.5', 'mariadb-client-5.5' %}
{{ pkg }}:
  pkg:
    - purged
    - name: {{ pkg }}
    - require_in:
      - file: /etc/mysql
    - require:
      - service: mariadb-server
{%- endfor %}
