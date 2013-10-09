Pillar
======

Mandatory
---------

Example::

  rabbitmq:
    cluster:
      master: node-1
      cookie: xxx
      nodes:
        node-1:
          private: 192.168.1.1
          public: 20.168.1.1
        node-2:
          private: 192.168.1.2
          public: 20.168.1.2
    vhosts:
      vhostname: vhostpassword
    monitor:
      user: monitor
      password: xxx
    management:
      user: admin
      password: xxx
    hostnames:
      - rmq.example.com

rabbitmq:cluster:master
~~~~~~~~~~~~~~~~~~~~~~~

Master node ID.

rabbitmq:cluster:cookie
~~~~~~~~~~~~~~~~~~~~~~~

Random string used as the Erlang cookie.

rabbitmq:cluster:nodes:{{ node id }}:private
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

IP/Hostname in LAN of RabbitMQ node.

rabbitmq:cluster:nodes:{{ node id }}:public
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

IP/Hostname reachable from Internet of RabbitMQ node.

rabbitmq:vhosts
~~~~~~~~~~~~~~~

Dict of {'vhostname': 'password'} of all RabbitMQ virtualhosts.

rabbitmq:monitor:user
~~~~~~~~~~~~~~~~~~~~~

Username used to perform monitoring check.

rabbitmq:monitor:password
~~~~~~~~~~~~~~~~~~~~~~~~~

Password used to perform monitoring check.

rabbitmq:management:user
~~~~~~~~~~~~~~~~~~~~~~~~

Username used to perform management trough Web UI.

rabbitmq:management:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Password used to perform management trough Web UI.

rabbitmq:hostnames
~~~~~~~~~~~~~~~~~~

List of hostnames that RabbitMQ management console is reachable.

Optional
--------

Example::

  rabbitmq:
    ssl: example.com
  shinken_pollers:
    - 192.168.1.1
  destructive_absent: False

destructive_absent
~~~~~~~~~~~~~~~~~~

If True (not default), RabbitMQ data saved on disk is purged
when rabbitmq.absent is executed.
