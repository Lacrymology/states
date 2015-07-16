{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

mysql_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/MySQLCollector.conf

{{ opts['cachedir'] }}/pip/mariadb.server:
  file:
    - absent
