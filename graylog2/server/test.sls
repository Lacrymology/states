include:
  - graylog2.server
  - graylog2.server.diamond
  - graylog2.server.nrpe

{#- Graylog2 requires a running Elasticsearch server to work
  properly. Check will definitively fail. #}

test:
  nrpe:
    - run_all_checks
    - exclude:
      - elasticsearch_nginx_http
      - graylog2_elasticsearch_cluster
      - graylog2_incoming_logs
    - require:
      - nrpe: elasticsearch_nginx_http
      - nrpe: graylog2_elasticsearch_cluster
      - nrpe: graylog2_incoming_logs

elasticsearch_nginx_http:
  nrpe:
    - run_check
    - wait: 60
    - order: last
    - accepted_failure: Invalid HTTP response received

graylog2_elasticsearch_cluster:
  nrpe:
    - run_check
    - order: last
    - accepted_failure: 0 nodes in cluster (outside 2:2)

graylog2_incoming_logs:
  nrpe:
    - run_check
    - order: last
    - accepted_failure: ClusterBlockException
