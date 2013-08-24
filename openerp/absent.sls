{%- set version = "6.1" %}

openerp{{ version }}-full:
  pkg:
    - purged
    - require:
      - service: openerp-server

openerp{{ version }}-core:
  pkg:
    - purged
    - require:
      - service: openerp-server

openerp-server:
  service:
    - dead

openerp:
  user:
    - absent
    - force: True
  postgres_user:
    - absent

/etc/openerp:
  file:
    - absent
    - require:
      - pkg: openerp{{ version }}-full

{%- for file in ('/etc/nginx/conf.d/openerp.conf', '/var/log/nginx/openerp_access.log', '/var/log/openerp-server.log') %}
{{ file }}:
  file:
    - absent
{%- endfor %}
