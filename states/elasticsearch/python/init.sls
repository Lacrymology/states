include:
  - pip

pyelasticsearch:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pyelasticsearch-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://elasticsearch/python/requirements.jinja2.jinja2
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pyelasticsearch-requirements.txt
    - require:
      - pkg: python-pip
    - watch:
      - file: pyelasticsearch
