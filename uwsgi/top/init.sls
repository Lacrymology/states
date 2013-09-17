{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - uwsgi

uwsgitop:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/salt-uwsgitop-requirements.txt
    - source: salt://uwsgi/top/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/salt-uwsgitop-requirements.txt
    - watch:
      - file: uwsgitop
    - require:
      - module: pip
