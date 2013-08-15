{%- for pkg in 'openerp6.1-full', 'openerp6.1-core' %}
{{ pkg }}:
  pkg:
    - purged
    - require:
      - service: openerp-server
{%- endfor %}

openerp-server:
  service:
    - dead
    - require:
      - user: openerp

openerp:
  user:
    - absent
    - force: True

/etc/openerp:
  file:
    - absent
    - require:
      - pkg: openerp6.1-full

/etc/nginx/sites-enabled/openerp:
  file:
    - absent

/etc/nginx/sites-available/openerp:
  file:
    - absent
