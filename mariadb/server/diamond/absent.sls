{#
 Turn off Diamond statistics for MariaDB
#}
/etc/diamond/collectors/MySQLCollector.conf:
  file:
    - absent

/usr/local/diamond/salt-mysql-requirements.txt:
  file:
    - absent
