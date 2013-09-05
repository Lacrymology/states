{#-
Uninstall OpenERP
=================
#}
{%- set version = "6.1" %}

openerp{{ version }}-core:
  pkg:
    - purged
    - require:
      - service: openerp-server

openerp-server:
  pkg:
    - purged
    - name: openerp{{ version }}-full
    - require:
      - service: openerp-server
  service:
    - dead
  user:
    - absent
    - name: openerp
    - force: True
  file:
    - absent
    - name: /etc/openerp

{%- for file in ('/etc/nginx/conf.d/openerp.conf', '/var/log/nginx/openerp_access.log', '/var/log/openerp-server.log') %}
{{ file }}:
  file:
    - absent
{%- endfor %}
