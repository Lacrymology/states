{#
 Turn off Diamond statistics for Elasticsearch
 #}
{% if 'graphite_address' in pillars %}
include:
  - diamond

extend:
  diamond:
    service:
      - watch:
        - file: /etc/diamond/collectors/ElasticSearchCollector.conf
{% endif %}

/etc/diamond/collectors/ElasticSearchCollector.conf:
  file:
    - absent
