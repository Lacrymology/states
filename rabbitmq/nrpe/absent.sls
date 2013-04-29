{#
 Remove Nagios NRPE check for RabbitMQ
#}
{% if 'shinken_pollers' in pillar %}

include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/rabbitmq.cfg
        - file: /etc/nagios/nrpe.d/rabbitmq-web.cfg
{% endif %}

/etc/nagios/nrpe.d/rabbitmq-web.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/rabbitmq.cfg:
  file:
    - absent
