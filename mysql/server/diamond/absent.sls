{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

mysql_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/MySQLCollector.conf

{{ opts['cachedir'] }}/pip/mariadb.server:
  file:
    - absent

{%- from 'diamond/macro.jinja2' import fail2ban_count_ip_absent with context %}
{{ fail2ban_count_ip_absent('mysqld-auth') }}
