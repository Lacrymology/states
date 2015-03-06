include:
  - ejabberd.absent
  - etherpad.absent
  - gitlab.absent
  - pgbouncer.absent
  - postgresql.server.absent
  - proftpd.absent
  - uwsgi.absent
{%- set company_db = salt['pillar.get']('openerp:company_db', False) %}
{%- if company_db %}
  - openerp.absent
{%- endif %}

extend:
  postgresql:
    service:
      - require:
        - service: ejabberd
        - service: etherpad
        - service: gitlab
        - service: pgbouncer
        - service: proftpd
        - service: uwsgi
{%- if company_db %}
        - service: openerp
{%- endif %}
