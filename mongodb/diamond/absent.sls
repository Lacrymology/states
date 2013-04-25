{#
 Turn off  Diamond statistics for MongoDB
#}
{% if 'graphite_address' in pillars %}
include:
  - diamond

extend:
  diamond:
    service:
      - watch:
        - file: /etc/diamond/collectors/MongoDBCollector.conf
{% endif %}

/usr/local/diamond/salt-pymongo-requirements.txt:
  file:
    - absent

/etc/diamond/collectors/MongoDBCollector.conf:
  file:
    - absent
