{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Turn off Diamond statistics for PostgreSQL Server
-#}
/usr/local/diamond/salt-postgresql-requirements.txt:
  file:
    - absent

postgresql_diamond_collector:
  file:
    - name: /etc/diamond/collectors/PostgresqlCollector.conf
    - absent
