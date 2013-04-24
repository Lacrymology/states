{#
 Nagios NRPE checks for elasticsearch
 #}
{% set ssl = pillar['elasticsearch']['ssl']|default(False) and 'public' in pillar['elasticsearch']['cluster']['nodes'][grains['id']] %}
include:
  - nrpe
  - requests

/etc/nagios/nrpe.d/elasticsearch.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://elasticsearch/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

/etc/nagios/nrpe.d/elasticsearch-nginx.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nginx/nrpe/instance.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: elasticsearch
      http_port: 9200
      domain_name: 127.0.0.1
      https: {{ ssl }}

/usr/local/bin/check_elasticsearch_cluster.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_elasticsearch_cluster.py:
  file:
    - managed
    - source: salt://elasticsearch/nrpe/check.py
    - mode: 555
    - require:
      - module: nagiosplugin
      - module: requests

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/elasticsearch.cfg
        - file: /etc/nagios/nrpe.d/elasticsearch-nginx.cfg
