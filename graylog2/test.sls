include:
{%- for state in ('graylog2.server', 'graylog2.web', 'elasticsearch') %}
  - {{ state }}
  - {{ state }}.diamond
  - {{ state }}.nrpe
{%- endfor %}

test:
  nrpe:
    - run_all_checks
    - order: last
    - wait: 60
    - exclude:
      - elasticsearch_cluster

graylog2_elasticsearch_cluster:
  nrpe:
    - run_check
    - wait: 60
    - order: last
    - accepted_failure: 1 nodes in cluster (outside 2:2)
