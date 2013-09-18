{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Turn off Diamond statistics for MariaDB
-#}
mysql_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/MySQLCollector.conf

/usr/local/diamond/salt-mysql-requirements.txt:
  file:
    - absent
