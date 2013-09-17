{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Diamond statistics for RabbitMQ
-#}
diamond_rabbitmq:
  file:
    - absent
    - name: /etc/diamond/collectors/RabbitMQCollector.conf

/usr/local/diamond/salt-pyrabbit-requirements.txt:
  file:
    - absent
