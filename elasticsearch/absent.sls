{#
 Uninstall an Elasticsearch NoSQL server
 #}
include:
  - apt

{% for filename in ('/etc/default/elasticsearch', '/etc/elasticsearch', '/etc/cron.daily/elasticsearch-cleanu') %}
{{ filename }}:
  file:
    - absent
    - require:
      - service: elasticsearch
{% endfor %}

/etc/nginx/conf.d/elasticsearch.conf:
  file:
    - absent
    - require:
      - service: elasticsearch

{% if grains['cpuarch'] == 'i686' %}
/usr/lib/jvm/java-7-openjdk:
  file:
    - absent
    - require:
      - pkg: elasticsearch
{% endif %}

elasticsearch:
  pkg:
{% if pillar['destructive_absent']|default(False) %}
    - purged
{% else %}
    - removed
{% endif %}
    - require:
      - service: elasticsearch
  service:
    - dead
    - enable: False
