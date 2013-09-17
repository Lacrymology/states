{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Install Raven (Sentry client-side python library) into OS/root site-packages.
 -#}
include:
  - pip

{{ opts['cachedir'] }}/raven-requirements.txt:
 file:
   - absent

raven:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/salt-raven-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://raven/requirements.jinja2
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/salt-raven-requirements.txt
    - require:
      - module: pip
    - watch:
      - file: raven
