{#-
Installing OpenERP
==================

Mandatory Pillar
----------------
openerp:
  nginx:
    server_names:
      - localhost       # list of hostname, used for nginx config

Optional Pillar
---------------

openerp:
  version: 6.1          # Default is 6.1
  database:
    host: 127.0.0.1     # if run postgresql in local
    port: 5432          # Default port for postgresql server
    user: openerp       
    password: False     # `False` is no password

-#}
include:
  - nginx
  - pip  
  - postgresql.server
  - python.dev
  - underscore

{%- set version =  salt[pillar.get]('openerp:version','6.1') %}
openerp-server:
  pkg:
    - installed
    - name: openerp{{ version }}-full
    - require:
      - pkg: libjs-underscore
      - service: postgresql
      - pip: openerp-server
  file:
    - managed
    - name: /etc/openerp/openerp-server.conf
    - source: salt://openerp/config.jinja2
    - user: openerp
    - group: openerp
    - mode: 440
    - template: jinja
    - require:
      - pkg: openerp-server
  service:
    - running
    - name: openerp-server
    - enable: True
    - order: 50
    - require:
      - pkg: openerp-server
    - watch:
      - file: openerp-server
  pip:
    - installed
    - name: pil
    - require:
      - pkg: python-dev
      - module: pip

/etc/nginx/conf.d/openerp.conf:
  file:
    - managed
    - source: salt://openerp/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - template: jinja
    - require:
      - service: openerp-server
    - watch_in:
      - service: nginx
