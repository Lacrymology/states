{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Execute this state only when mongodb or the server crashed and it requires
 a repair.
-#}

{%- if salt['file.file_exists']('/usr/bin/mongod') %}
mongodb_repair:
  service:
    - dead
  cmd:
    - run
    - name: /usr/bin/mongod --config /etc/mongodb.conf --repair
    - require:
       - service: mongodb_repair

mongodb:
  cmd:
    - run
    - name: chown -R mongodb:nogroup /var/lib/mongodb
    - require:
      - cmd: mongodb_repair
  service:
    - running
    - require:
      - cmd: mongodb
{%- endif -%}
