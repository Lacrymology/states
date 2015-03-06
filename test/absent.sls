include:
  - diamond.absent
  - ejabberd.absent
  - etherpad.absent
  - gitlab.absent
  - graylog2.server.absent
  - graylog2.web.absent
  - mongodb.absent
  - nrpe.absent
  - pgbouncer.absent
  - postgresql.server.absent
  - proftpd.absent
  - redis.absent
  - rsyslog.absent
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
  mongodb:
    service:
      - require:
        - service: graylog2-server
        - service: graylog2-web
  redis:
    service:
      - require:
        - service: gitlab
  nsca_passive:
    service:
      - order: last
  nagios-nrpe-server:
    service:
      - order: last
  diamond:
    service:
      - order: last
  rsyslog:
    service:
      - order: last
