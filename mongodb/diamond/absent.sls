{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{{ opts['cachedir'] }}/pip/mongodb.diamond:
  file:
    - absent

diamond_mongodb:
  file:
    - absent
    - name: /etc/diamond/collectors/MongoDBCollector.conf
