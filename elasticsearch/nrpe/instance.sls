{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - nrpe

/usr/local/bin/check_elasticsearch_cluster.py:
  file:
    - absent

pyelasticsearch:
  file:
    - managed
    - name: /usr/local/nagios/salt-elasticsearch-requirements.txt
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
    - requirements: /usr/local/nagios/salt-elasticsearch-requirements.txt
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
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive
