{#
 Turn off  Diamond statistics for MongoDB
#}
/usr/local/diamond/salt-pymongo-requirements.txt:
  file:
    - absent

/etc/diamond/collectors/MongoDBCollector.conf:
  file:
    - absent
