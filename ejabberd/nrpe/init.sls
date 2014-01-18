include:
  - apt.nrpe
  - nginx.nrpe
  - nrpe
  - postgresql.server.nrpe

/etc/nagios/nrpe.d/ejabberd.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://ejabberd/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - watch_in:
      - service: nagios-nrpe-server

/etc/nagios/nrpe.d/ejabberd-nginx.cfg:
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
      deployment: ejabberd
      domain_name: {{ pillar['ejabberd']['hostnames'][0] }}
      http_uri: /admin
{%- if salt['pillar.get']('ejabberd:ssl', False) %}
      https: True
    {%- if salt['pillar.get']('ejabberd:ssl_redirect', False) %}
      http_result: 301 Moved Permanently
    {%- endif -%}
{%- else %}
      http_result: 401 Unauthorized
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server

/etc/nagios/nrpe.d/postgresql-ejabberd.cfg:
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
      database: {{ salt['pillar.get']('ejabberd:db:name', 'ejabberd') }}
      username: {{ salt['pillar.get']('ejabberd:db:username', 'ejabberd') }}
      password: {{ salt['password.pillar']('ejabberd:db:password', 10) }}
    - watch_in:
      - service: nagios-nrpe-server
