{%- set ssl = pillar['elasticsearch']['ssl']|default(False) %}
include:
  - elasticsearch
  - elasticsearch.diamond
  - elasticsearch.nrpe
{% if ssl %}
  - ssl.nrpe
  - nginx.diamond
  - nginx.nrpe
{% endif %}

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
