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
    - order: last
  nrpe:
    - run_all_checks
    - exclude:
      - elasticsearch_cluster
    - require:
      - module: test

elasticsearch_cluster:
  nrpe:
    - run_check
    - accepted_failure: 1 nodes in cluster (outside 2:2)
    - require:
      - module: test
