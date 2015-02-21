{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

diamond-pymongo:
  file:
    - absent
    - name: /usr/local/diamond/salt-mongodb-requirements.txt

diamond_mongodb:
  file:
    - absent
    - name: /etc/diamond/collectors/MongoDBCollector.conf
