{#-
Nagios NRPE check for OpenERP
#}

include:
  - nrpe
  - apt.nrpe
  - nginx.nrpe
  - pip.nrpe
  - postgresql.server.nrpe
{%- if pillar['openerp']['ssl']|default(False) %}
  - ssl.nrpe
{%- endif %} 
  - underscore.nrpe

/etc/nagios/nrpe.d/openerp-server.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://openerp/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - watch_in:
      - service: nagios-nrpe-server

/etc/nagios/nrpe.d/openerp-nginx.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nginx/nrpe/instance.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: openerp
      domain_name: {{ salt['pillar.get']('openerp:hostnames)[0] }}
      http_uri: /
{%- if pillar['openerp']['ssl']|default(False) %}
      https: True
      http_result: 301 Moved Permanently
{%- endif %}

/etc/nagios/nrpe.d/postgresql-openerp.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://postgresql/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: openerp
      password: {{ salt['password.pillar']('openerp:database:password', 10) }}
    - watch_in:
      - service: nagios-nrpe-server
