{#
 Nagios NRPE checks for elasticsearch
 #}
{% set ssl = pillar['elasticsearch']['ssl']|default(False) and 'public' in pillar['elasticsearch']['cluster']['nodes'][grains['id']] %}
include:
  - nrpe
  - apt.nrpe
  - cron.nrpe
{% if ssl %}
  - ssl.nrpe
  - nginx.nrpe
{% endif %}

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

pyelasticsearch:
  file:
    - managed
    - name: /usr/local/nagios/elasticsearch-requirements.txt
    - source: salt://elasticsearch/nrpe/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - module: nrpe-virtualenv
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: /usr/local/nagios/elasticsearch-requirements.txt
    - require:
      - virtualenv: nrpe-virtualenv
    - watch:
      - file: pyelasticsearch

/usr/lib/nagios/plugins/check_elasticsearch_cluster.py:
  file:
    - managed
    - source: salt://elasticsearch/nrpe/check.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: pyelasticsearch
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/elasticsearch.cfg
        - file: /etc/nagios/nrpe.d/elasticsearch-nginx.cfg
