{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set web_root_dir = "/usr/local/openerp" %}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('openerp') }}

extend:
  openerp:
    group:
      - absent
      - require:
        - user: openerp
    user:
      - absent
      - name: openerp
      - force: True

{{ web_root_dir }}:
    file:
      - absent

openerp-uwsgi:
  file:
    - absent
    - name: /etc/uwsgi/openerp.yml
    - require:
      - file: /etc/nginx/conf.d/openerp.conf

/usr/local/openerp/config.yaml:
  file:
    - absent

/etc/nginx/conf.d/openerp.conf:
  file:
    - absent

{{ opts['cachedir'] }}/pip/openerp:
  file:
    - absent
