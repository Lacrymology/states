{#-
 Install a GitLab Nagios NRPE checks
#}
include:
  - apt.nrpe
  - build.nrpe
  - git.nrpe
  - logrotate.nrpe
  - nginx.nrpe
  - nodejs.nrpe
  - nrpe
  - postgresql.nrpe
  - postgresql.server.nrpe
  - python.nrpe
  - redis.nrpe
  - ruby.nrpe
{%- if salt['pillar.get']('gitlab:ssl', False) %}
  - ssl.nrpe
{%- endif %}
  - uwsgi.nrpe

/etc/nagios/nrpe.d/gitlab.cfg:
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
      deployment: gitlab
      workers: {{ salt['pillar.get']('gitlab:workers', "2") }}
{%- if 'cheaper' in salt['pillar.get']('gitlab') %}
      cheaper: {{ salt['pillar.get']('gitlab:cheaper')  }}
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server

/etc/nagios/nrpe.d/gitlab-nginx.cfg:
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
      deployment: gitlab
      domain_name: {{ salt['pillar.get']('gitlab:hostnames')[0] }}
      http_uri: /login
{%- if salt['pillar.get']('gitlab:ssl', False) %}
      https: True
      http_result: 301 Moved Permanently
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server

/etc/nagios/nrpe.d/postgresql-gitlab.cfg:
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
      deployment: gitlab
      password: {{  salt['password.pillar']('gitlab:database:password', 10) }}
    - watch_in:
      - service: nagios-nrpe-server
