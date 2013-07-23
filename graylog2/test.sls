include:
{%- for state in ('graylog2.server', 'graylog2.web', 'elasticsearch') %}
  - {{ state }}
  - {{ state }}.diamond
  - {{ state }}.nrpe
{%- endfor %}

test:
  module:
    - run
    - name: nrpe.wait
    - seconds: 60
    - require:
      - nrpe: test
      - nrpe: elasticsearch_cluster
  nrpe:
    - run_all_checks
    - order: last
    - exclude:
      - elasticsearch_cluster

elasticsearch_cluster:
  nrpe:
    - run_check
    - order: last
    - accepted_failure: 1 nodes in cluster (outside 2:2)
