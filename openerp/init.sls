{#-
Installing OpenERP
===============

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file

openerp:
  nginx:
    server_name: localhost
  database:
    host: 127.0.0.1
    post: 5432
    user: openerp
    password: False

-#}
include:
  - nginx
  - postgresql
  - underscore

openerp-server:
  pkg:
    - installed
    - name: openerp6.1-full
    - require:
      - pkg: libjs-underscore
      - service: postgresql
  service:
    - running
    - enable: True
    - require:
      - pkg: openerp-server
    - watch:
      - file: /etc/openerp/openerp-server.conf

/etc/openerp/openerp-server.conf:
  file:
    - managed
    - source: salt://openerp/config.jinja2
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - require:
      - pkg: openerp-server

/etc/nginx/conf.d/openerp:
  file:
    - managed
    - source: salt://openerp/nginx.jinja2
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - require:
      - service: openerp-server
    - watch_in:
      - service: nginx
