{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
mysql_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/MySQLCollector.conf

/usr/local/diamond/salt-mysql-requirements.txt:
  file:
    - absent
