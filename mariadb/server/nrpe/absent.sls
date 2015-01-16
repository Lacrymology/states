{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
/etc/nagios/nrpe.d/mysql.cfg:
  file:
    - absent

/usr/lib/nagios/plugins/check_mysql_query.py:
  file:
    - absent

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('mariadb.server') }}
