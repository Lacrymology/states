{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{% set ssl = salt['pillar.get']('elasticsearch:ssl', False) %}
include:
  - elasticsearch
  - cron.diamond
  - diamond
  - rsyslog.diamond
{% if ssl %}
  - nginx.diamond
{% endif %}

elasticsearch_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require:
      - process: elasticsearch_diamond_resources
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[elasticsearch]]
        cmdline = .+java.+\-cp \:\/usr\/share\/elasticsearch\/lib\/elasticsearch\-.+\.jar
  process:
    - wait_socket
    - address: "127.0.0.1"
    - port: 9200
    - require:
      - service: elasticsearch

/etc/diamond/collectors/ElasticSearchCollector.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://elasticsearch/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors
      - service: elasticsearch
    - watch_in:
      - service: diamond
