{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

diamond_rabbitmq:
  file:
    - absent
    - name: /etc/diamond/collectors/RabbitMQCollector.conf

{{ opts['cachedir'] }}/pip/rabbitmq.diamond:
  file:
    - absent
