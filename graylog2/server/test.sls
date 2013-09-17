{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
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
      - graylog2_elasticsearch_cluster
      - graylog2_incoming_logs
      - elasticsearch_nginx_http
