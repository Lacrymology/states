{#
 Nagios NRPE check for RabbitMQ
#}
include:
  - nrpe
  - apt.nrpe
  - logrotate.nrpe
{% if pillar['rabbitmq']['management'] != 'guest' -%}
  {%- if pillar['rabbitmq']['ssl']|default(False) %}
  - ssl.nrpe
  {%- endif %}
  - nginx.nrpe
{% endif %}

/etc/nagios/nrpe.d/rabbitmq-web.cfg:
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
      deployment: rabbitmq
      http_port: 15672
      domain_name: 127.0.0.1
{% if pillar['rabbitmq']['management'] != 'guest' %}
      https: {{ pillar['rabbitmq']['ssl']|default(False) }}
{% else %}
      https: False
{% endif %}

/etc/nagios/nrpe.d/rabbitmq.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://rabbitmq/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/rabbitmq.cfg
        - file: /etc/nagios/nrpe.d/rabbitmq-web.cfg
