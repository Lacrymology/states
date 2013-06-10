{#
 Nagios NRPE check for Shinken
#}
include:
  - nrpe
  - virtualenv.nrpe
  - pip.nrpe
  - python.dev.nrpe
  - apt.nrpe
{% if pillar['shinken']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}
  - nginx.nrpe
  - gsyslog.nrpe

/etc/nagios/nrpe.d/shinken-broker.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://shinken/broker/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

/etc/nagios/nrpe.d/shinken-nginx.cfg:
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
      deployment: shinken_broker
      http_uri: /user/login
      domain_name: {{ pillar['shinken']['web']['hostnames'][0] }}
      http_port: 7767
      https: {{ pillar['shinken']['ssl']|default(False) }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/shinken-broker.cfg
        - file: /etc/nagios/nrpe.d/shinken-nginx.cfg
