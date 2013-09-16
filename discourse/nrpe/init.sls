{#-
 Install a Discourse Nagios NRPE checks
#}
include:
  - apt.nrpe
  - build.nrpe
  - git.nrpe
  - logrotate.nrpe
  - nginx.nrpe
  - nrpe
  - postgresql.nrpe
  - postgresql.server.nrpe
  - redis.nrpe
  - ruby.nrpe
{%- if salt['pillar.get']('discourse:ssl', False) %}
  - ssl.nrpe
{%- endif %}
  - xml.nrpe
  - uwsgi.nrpe

/etc/nagios/nrpe.d/discourse.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://uwsgi/nrpe/instance.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: discourse
      workers: {{ salt['pillar.get']('discourse:workers', '2') }}
{%- if 'cheaper' in salt['pillar.get']('discourse') %}
      cheaper: {{ salt['pillar.get']('discourse:cheaper') }}
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server

/etc/nagios/nrpe.d/discourse-nginx.cfg:
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
      deployment: discourse
      domain_name: {{ salt['pillar.get']('discourse:hostnames')[0] }}
      http_uri: /
{%- if salt['pillar.get']('discourse:ssl', False) %}
      https: True
      http_result: 301 Moved Permanently
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server

/etc/nagios/nrpe.d/postgresql-discourse.cfg:
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
      deployment: discourse
      password: {{  salt['password.pillar']('discourse:database:password') }}
    - watch_in:
      - service: nagios-nrpe-server

