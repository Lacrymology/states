{#
 Diamond statistics for Graylog2 Server
#}
include:
  - diamond
{#  - elasticsearch.diamond #}
  - mongodb.diamond

graylog2_server_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[graylog2]]
        cmdline = ^java.+\-jar \/usr\/local\/graylog2\-server\-.+\/graylog2-server.jar
