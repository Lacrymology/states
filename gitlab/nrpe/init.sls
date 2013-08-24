{#-
 Install a GitLab Nagios NRPE checks
#}
include:
  - apt.nrpe
  - build.nrpe
  - nginx.nrpe
  - nrpe
  - postgresql.server.nrpe
  - python.nrpe
  - redis.nrpe
  - ruby.nrpe
{%- if salt['pillar.get']('gitlab:config:ssl', False) %}
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
{% if 'cheaper' in salt['pillar.get']('gitlab') %}
      cheaper: {{ salt['pillar.get']('gitlab:cheaper')  }}
{% endif %}

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
{%- if salt['pillar.get']('gitlab:config:ssl', False) %}
      https: True
      http_result: 301 Moved Permanently
{%- endif %}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/gitlab.cfg
        - file: /etc/nagios/nrpe.d/gitlab-nginx.cfg

