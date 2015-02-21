{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

diamond_rabbitmq:
  file:
    - absent
    - name: /etc/diamond/collectors/RabbitMQCollector.conf

diamond-pyrabbit:
  file:
    - absent
    - name: /usr/local/diamond/salt-rabbitmq-requirements.txt
