{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
diamond_rabbitmq:
  file:
    - absent
    - name: /etc/diamond/collectors/RabbitMQCollector.conf

diamond-pyrabbit:
  file:
    - absent
    - name: /usr/local/diamond/salt-rabbitmq-requirements.txt

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/diamond/salt-pyrabbit-requirements.txt:
  file:
    - absent
