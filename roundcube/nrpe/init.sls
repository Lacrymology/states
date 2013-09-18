{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Install a roundcube Nagios NRPE checks
-#}
include:
  - nrpe
  - apt.nrpe
  - nginx.nrpe
  - uwsgi.nrpe
  - build.nrpe
  - rsyslog.nrpe
  - postgresql.nrpe
  - postgresql.server.nrpe
{% if pillar['roundcube']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}

/etc/nagios/nrpe.d/roundcube.cfg:
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
      deployment: roundcube
      workers: {{ pillar['roundcube']['workers'] }}
{% if 'cheaper' in pillar['roundcube'] %}
      cheaper: {{ pillar['roundcube']['cheaper'] }}
{% endif %}

/etc/nagios/nrpe.d/roundcube-nginx.cfg:
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
      deployment: roundcube
      domain_name: {{ pillar['roundcube']['hostnames'][0] }}
      http_uri: /
{%- if pillar['roundcube']['ssl']|default(False) %}
      https: True
    {%- if pillar['roundcube']['ssl_redirect']|default(False) %}
      http_result: 301 Moved Permanently
    {%- endif -%}
{%- endif %}

/etc/nagios/nrpe.d/postgresql-roundcube.cfg:
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
      deployment: roundcube
      password: {{ pillar['roundcube']['password'] }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/roundcube.cfg
        - file: /etc/nagios/nrpe.d/roundcube-nginx.cfg
        - file: /etc/nagios/nrpe.d/postgresql-roundcube.cfg
