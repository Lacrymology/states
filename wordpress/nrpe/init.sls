{#
 Install a wordpress Nagios NRPE checks
#}
include:
  - nrpe
  - apt.nrpe
  - nginx.nrpe
  - uwsgi.nrpe
  - build.nrpe
  - gsyslog.nrpe
  - postgresql.nrpe
  - postgresql.server.nrpe
{% if pillar['wordpress']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}

/etc/nagios/nrpe.d/wordpress.cfg:
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
      deployment: wordpress
      workers: {{ pillar['wordpress']['workers'] }}
{% if 'cheaper' in pillar['wordpress'] %}
      cheaper: {{ pillar['wordpress']['cheaper'] }}
{% endif %}

/etc/nagios/nrpe.d/wordpress-nginx.cfg:
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
      deployment: wordpress
      domain_name: {{ pillar['wordpress']['hostnames'][0] }}
      http_uri: /
{%- if pillar['wordpress']['ssl']|default(False) %}
      https: True
    {%- if pillar['wordpress']['ssl_redirect']|default(False) %}
      http_result: 301 Moved Permanently
    {%- endif -%}
{%- endif %}

/etc/nagios/nrpe.d/postgresql-wordpress.cfg:
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
      deployment: wordpress
      password: {{ pillar['wordpress']['password'] }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/wordpress.cfg
        - file: /etc/nagios/nrpe.d/wordpress-nginx.cfg
        - file: /etc/nagios/nrpe.d/postgresql-wordpress.cfg
