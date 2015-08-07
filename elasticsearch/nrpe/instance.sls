{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - nrpe

/usr/local/bin/check_elasticsearch_cluster.py:
  file:
    - absent

/usr/local/nagios/salt-elasticsearch-requirements.txt:
  file:
    - absent

pyelasticsearch:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/elasticsearch
    - source: salt://elasticsearch/nrpe/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - virtualenv: nrpe-virtualenv
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: {{ opts['cachedir'] }}/pip/elasticsearch
    - watch:
      - file: pyelasticsearch

/usr/lib/nagios/plugins/check_elasticsearch_cluster.py:
  file:
    - managed
    - source: salt://elasticsearch/nrpe/check.py
    - user: root
    - group: nagios
    - mode: 550
    - require:
      - module: pyelasticsearch
      - module: nrpe-virtualenv
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive
