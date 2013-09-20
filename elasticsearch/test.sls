{#-
Author: Bruno Clermont patate@fastmail.cn
Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
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
  nrpe:
    - run_all_checks
    - order: last
    - wait: 60
    - exclude:
      - elasticsearch_cluster

elasticsearch_cluster:
  nrpe:
    - run_check
    - wait: 60
    - order: last
    - accepted_failure: 1 nodes in cluster (outside 2:2)
