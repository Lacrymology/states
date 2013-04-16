{#
 Install Route53 (Amazon Route53 client-side python library) into OS/root
 site-packages.
 #}
include:
  - pip
  - apt

python-lxml:
  pkg:
    - purged

route53:
  pkg:
    - installed
    - names:
      - libxml2-dev
      - libxslt1-dev
    - require:
      - cmd: apt_sources
      - pkg: python-lxml
  file:
    - managed
    - name: {{ opts['cachedir'] }}/salt-route53-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - source: salt://route53/requirements.jinja2
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - pkgs: ''
    - requirements: {{ opts['cachedir'] }}/salt-route53-requirements.txt
    - require:
      - pkg: python-pip
      - pkg: route53
    - watch:
      - file: route53
