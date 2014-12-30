{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Install Route53 (Amazon Route53 client-side python library) into OS/root
site-packages.
#}
include:
  - pip
  - python.dev
  - xml

python-lxml:
  pkg:
    - purged

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/salt-route53-requirements.txt:
  file:
    - absent

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
      - pkg: xml-dev
      - file: route53
      - pkg: python-dev
