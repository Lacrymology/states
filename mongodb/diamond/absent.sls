{#
 Turn off  Diamond statistics for MongoDB
#}
diamond-pymongo:
  file:
    - absent
    - name: /usr/local/diamond/salt-pymongo-requirements.txt

diamond_mongodb:
  file:
    - absent
    - name: /etc/diamond/collectors/MongoDBCollector.conf
