{#
 Nagios NRPE check for Salt-API Server
#}
include:
  - nrpe

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
      http_result: 301 Moved
      https_result: 401 Unauthorized
      domain_name: {{ pillar['salt_master']['hostnames'][0] }}
      https: {{ pillar['salt_master']['ssl']|default(False) }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-api.cfg
        - file: /etc/nagios/nrpe.d/salt-api-nginx.cfg
