{#-
Installing OpenERP
==================

Mandatory Pillar
----------------

Optional Pillar
---------------

openerp:
  version: 6.1
  nginx:
    server_name: localhost
  database:
    host: False     # set 'False' if run postgresql in local
    port: False
    user: openerp
    password: False

-#}
include:
  - nginx
  - pip  
  - postgresql.server
  - python.dev
  - underscore

{%- set version= pillar['openerp']['version']|default(6.1) %}
openerp-server:
  pkg:
    - installed
    - name: openerp{{ version }}-full
    - require:
      - pkg: libjs-underscore
      - service: postgresql
      - pip: pil
  service:
    - running
    - name: openerp-server
    - enable: True
    - require:
      - pkg: openerp-server
    - watch:
      - file: /etc/openerp/openerp-server.conf

pil:
  pip:
    - installed
    - require:
      - pkg: python-dev
      - module: pip

/etc/openerp/openerp-server.conf:
  file:
    - managed
    - source: salt://openerp/config.jinja2
    - user: openerp
    - group: openerp
    - mode: 640
    - template: jinja
    - require:
      - pkg: openerp-server

/etc/nginx/conf.d/openerp.conf:
  file:
    - managed
    - source: salt://openerp/nginx.jinja2
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - require:
      - service: openerp-server
    - watch_in:
      - service: nginx
