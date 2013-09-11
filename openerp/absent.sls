{#-
Uninstall OpenERP
=================
#}
{%- set web_root_dir = "/usr/local/openerp" %}

openerp:
  group:
    - absent
    - require:
      - user: openerp
  user:
    - absent
    - name: openerp
    - force: True
  file:
    - absent
    - name: {{ web_root_dir }}
    - name: /etc/openerp

{%- for file in ('/etc/nginx/conf.d/openerp.conf', '/etc/uwsgi/openerp.ini') %}
{{ file }}:
  file:
    - absent
{%- endfor %}
