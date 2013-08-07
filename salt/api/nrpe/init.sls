{#-
 Nagios NRPE check for Salt-API Server
-#}
{%- set ssl = pillar['salt_master']['ssl']|default(False) -%}
include:
  - nrpe
  - salt.master.nrpe
  - git.nrpe
  - apt.nrpe
  - nginx.nrpe
  - pip.nrpe
  - gsyslog.nrpe
{%- if ssl %}
  - ssl.nrpe
{%- endif %}

/etc/nagios/nrpe.d/salt-api.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://salt/api/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

/etc/nagios/nrpe.d/salt-api-nginx.cfg:
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
      deployment: salt_api
{%- if ssl %}
      http_result: 301 Moved
      https_result: 401 Unauthorized
{%- else %}
      http_result: 401 Unauthorized
{%- endif %}
      domain_name: {{ pillar['salt_master']['hostnames'][0] }}
      https: {{ ssl }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-api.cfg
        - file: /etc/nagios/nrpe.d/salt-api-nginx.cfg
