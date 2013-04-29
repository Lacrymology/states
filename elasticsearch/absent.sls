{#
 Uninstall an Elasticsearch NoSQL server
 #}
{% set ssl = pillar['elasticsearch']['ssl']|default(False) and 'public' in pillar['elasticsearch']['cluster']['nodes'][grains['id']] %}
include:
  - apt
{% if ssl %}
  - nginx

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/elasticsearch.conf
{% endif %}

{% for filename in ('/etc/default/elasticsearch', '/etc/elasticsearch', '/etc/cron.daily/elasticsearch-cleanu', '/etc/nginx/conf.d/elasticsearch.conf') %}
{{ filename }}:
  file:
    - absent
    - require:
      - service: elasticsearch
{% endfor %}

{% if grains['cpuarch'] == 'i686' %}
/usr/lib/jvm/java-7-openjdk:
  file:
    - absent
{% endif %}

elasticsearch:
  pkg:
{% if pillar['destructive_absent']|default(False) %}
    - purged
{% else %}
    - removed
{% endif %}
  service:
    - dead
    - enable: False
