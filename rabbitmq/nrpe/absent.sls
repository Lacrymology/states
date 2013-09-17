{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Remove Nagios NRPE check for RabbitMQ
-#}
/etc/nagios/nrpe.d/rabbitmq-web.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/rabbitmq.cfg:
  file:
    - absent
