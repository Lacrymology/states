{#
 Execute this state only when mongodb or the server crashed and it requires
 a repair.
#}

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
