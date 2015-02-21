{#- Usage of this is governed by a license that can be found in doc/license.rst

Install Route53 (Amazon Route53 client-side python library) into OS/root
site-packages.
-#}

include:
  - build
  - pip
  - python.dev
  - xml

python-lxml:
  pkg:
    - purged

route53:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/route53
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - source: salt://route53/requirements.jinja2
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pip/route53
    - require:
      - pkg: python-lxml
    - watch:
      - pkg: build
      - pkg: xml-dev
      - file: route53
      - pkg: python-dev
    - reload_modules: True
