{#
 Install pyelasticsearch python module in root OS python site-packages
 #}
include:
  - pip
  - requests

pyelasticsearch:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pyelasticsearch-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://elasticsearch/python/requirements.jinja2
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pyelasticsearch-requirements.txt
    - require:
      - pkg: python-pip
      - module: requests
    - watch:
      - file: pyelasticsearch
