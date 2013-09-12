{#-
Nagios NRPE check for OpenERP
#}

include:
  - nrpe
  - apt.nrpe
  - build.nrpe
  - nginx.nrpe
  - pip.nrpe
  - postgresql.server.nrpe
  - python.dev.nrpe
{%- if salt['pillar.get']('openerp:ssl', False) %}
  - ssl.nrpe
{%- endif %}
  - underscore.nrpe
  - uwsgi.nrpe
  - virtualenv.nrpe

/etc/nagios/nrpe.d/openerp.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://uwsgi/nrpe/instance.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - watch_in:
      - service: nagios-nrpe-server
    - context:
      deployment: openerp
      workers: {{ salt['pillar.get']('openerp:workers', '2') }}
      {%- if 'cheaper' in salt['pillar.get']('openerp') %}
      cheaper: {{ salt['pillar.get']('openerp:cheaper')  }}
      {%- endif %}

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
      domain_name: {{ salt['pillar.get']('openerp:hostnames')[0] }}
      http_uri: /
{%- if salt['pillar.get']('openerp:ssl', False) %}
      https: True
      http_result: 301 Moved Permanently
{%- endif %}

{#-
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
#}