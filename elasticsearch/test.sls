include:
  - elasticsearch
  - elasticsearch.diamond
  - elasticsearch.nrpe

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
