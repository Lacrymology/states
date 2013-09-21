{#
 Install a wordpress Nagios NRPE checks
#}
include:
  - nrpe
  - build.nrpe
  - mariadb.nrpe
  - mariadb.server.nrpe
  - nginx.nrpe
  - php.nrpe
{%- if salt['pillar.get']('wordpress:ssl', False) %}
  - ssl.nrpe
{%- endif %}
  - uwsgi.nrpe

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
      workers: {{ salt['pillar.get']('wordpress:workers', '2') }}
{%- if 'cheaper' in pillar['wordpress'] %}
      cheaper: {{ salt['pillar.get']('wordpress:cheaper') }}
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server

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
      domain_name: {{ salt['pillar.get']('wordpress:hostnames')[0] }}
      http_uri: /
{%- if salt['pillar.get']('wordpress:ssl', False) %}
      https: True
    {%- if salt['pillar.get']('wordpress:ssl_redirect', False) %}
      http_result: 301 Moved Permanently
    {%- endif -%}
{%- endif %}
    - watch_in:
      - service: nagios-nrpe-server

